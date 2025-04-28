%% wrong For cycle

for g = 4:mess_len

    code_block = [x_arr(g-3), x_arr(g-2), x_arr(g-1), x_arr(g)];
    for g1 = 1:3:35
        ids = find(gen1 == 1);
        checksum = 0;
        for id = ids
            id;
            if code_block(id) == 1
                checksum = checksum + code_block(id);
            end
        end
            
        if mod(checksum, 2) == 0
            output(g1) = 0;
        else
            output(g1) = 1;
        end

    end

    for g2 = 2:3:35
        ids = find(gen2 == 1);
        checksum = 0;
        for id = ids
            id;
            if code_block(id) == 1
                checksum = checksum + code_block(id);
            end
        end
            
        if mod(checksum, 2) == 0
            output(g2) = 0;
        else
            output(g2) = 1;
        end


    end

    for g3 = 3:3:35
        ids = find(gen3 == 1);
        checksum = 0;
        for id = ids
            id;
            if code_block(id) == 1
                checksum = checksum + code_block(id);
            end
        end
            
        if mod(checksum, 2) == 0
            output(g3) = 0;
        else
            output(g3) = 1;
        end


    end

end