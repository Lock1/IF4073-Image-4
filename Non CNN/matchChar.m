function matchCharRes = matchChar(K, T, template)
    matchCharRes = "";
    for z = 1: size(K, 3)
        i = templateMatching(K(:,:,z), T);
        matchCharRes = matchCharRes + template(i);
    end
end