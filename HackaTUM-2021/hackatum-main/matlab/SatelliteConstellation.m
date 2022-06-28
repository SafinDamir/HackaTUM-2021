startTime = datetime(2021,11,20,13,0,0);
stopTime = startTime + hours(4);
sampleTime = 30; % seconds
sc = satelliteScenario(startTime,stopTime,sampleTime);
%tleFile = "leoSatelliteConstellation.tle";
%tleFile = "leoSatelliteConstellation.tle";
%sat = satellite(sc,tleFile);

semiMajorAxis = 6900000; %major axis (r, meters)
eccentricity = 0;
inclination = 90; %inclination (i)
rightAscensionOfAscendingNode = 0; %longitude of ascending node (capital omega, degrees)
argumentOfPeriapsis = 0; %argument of periapsis (omega, degrees)
trueAnomaly = 0; %true anomaly (nu, degrees)
numOfOrbits = 6;
numOfSatellites = 11;

for i = 1:numOfOrbits 
    for j = 1:numOfSatellites
        sat((i-1)*numOfSatellites + j) = satellite(sc, semiMajorAxis, eccentricity, inclination, i * (180 / numOfOrbits), argumentOfPeriapsis, j * (360 / numOfSatellites) + i * (180 / numOfSatellites));
    end
end


for idx = 1:numel(sat)
    name = sat(idx).Name + " Camera";
    conicalSensor(sat(idx),"Name",name,"MaxViewAngle",179); %the angle of a satellite is not limited
end

xg = sphere_fibonacci_grid_points(6);
sph = oblateSpheroid;
[lat,lon,h] = ecef2geodetic(sph, xg(:,1), xg(:,2), xg(:,3));
numofplanes = size(lat, 1);
planeName = string([1:numofplanes]);
minElevationAngle = 10; % degrees
maxElevationAngle = 75; % degrees
plane = groundStation(sc, "Name", planeName, "MinElevationAngle",minElevationAngle, "Longitude", lon, "Latitude", lat, "Altitude", 10000); %the average height of a plane is 10000m

% Retrieve the cameras
for j=1:numofplanes
    cam(j,:) = [sat.ConicalSensors];
end

v = satelliteScenarioViewer(sc);
fov1 = fieldOfView(cam([cam.Name] == "Satellite 14 Camera"));
fov2 = fieldOfView(cam([cam.Name] == "Satellite 6 Camera"));
%hide([sat.Orbit]);


play(sc);
for j = 1:numofplanes
    clear ac;
    for idx = 1:numel(cam(j,:))
        ac(idx) = access(cam(j,idx), plane(j));
        %access(cam(idx),plane);
    end
    clear systemWideAccessStatus;
    clear s;
    clear time;
    curac = ac;
    for idx = 1:numel(ac)
        [s,time] = accessStatus(ac(idx));
        
        if idx == 1
            systemWideAccessStatus = s;
        else
            systemWideAccessStatus = or(systemWideAccessStatus,s);
        end
    end
    resultPercentage(j, :) = systemWideAccessStatus;
end

resultAccessCoverage = 0;
for j=1:numofplanes
    n = nnz(resultPercentage(j, :));
    systemWideAccessDuration = n*sc.SampleTime; % seconds
    scenarioDuration = seconds(sc.StopTime - sc.StartTime);
    systemWideAccessPercentage = (systemWideAccessDuration/scenarioDuration)*100;
    fprintf("Access precentage of the plane %i is %f %.", j, systemWideAccessPercentage);
    fprintf('\n');
%     plot(time,resultPercentage(j, :),"LineWidth",2);
%     grid on;
%     xlabel("Time");
%     ylabel("System-Wide Access Status");
    resultAccessCoverage = resultAccessCoverage + systemWideAccessPercentage;
end
resultAccessCoverage = resultAccessCoverage / numofplanes;
fprintf("Average access perecentage is %f %.", resultAccessCoverage);
fprintf('\n');
