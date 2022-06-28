

param_a = 0.2;
param_b = 0.7;
rno = 0;
for c = 1:100
    rno = rno + 1;
    j = gen_human_move(rno);
    r = rand
    switch r
        case (r < param_a)
            disp('case1')
        case ((r >= param_a) && (r <= param_b))
            disp('case2')
        otherwise 
            disp('case3')
    end
end
