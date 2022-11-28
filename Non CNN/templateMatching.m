function matchRes = templateMatching(I, T)
    maxMatch = 0;
    matchRes = 0;
    for z = 1: size(T, 3)
        m = bwarea(~xor(I, T(:,:,z)));
        if m > maxMatch
            maxMatch = m;
            matchRes = z;
        end
    end
end