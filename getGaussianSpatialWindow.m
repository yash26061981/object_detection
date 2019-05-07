function g = getGaussianSpatialWindow(mu,sig,len)

    g = zeros(1,len);
    f1mult = 1/(2*pi*sig*sig);
    indx = 1;
    for x = -(len-1)/2:(len-1)/2
        g(indx) = f1mult * exp(-1* ((x-mu)*(x-mu))/(2*sig*sig));
        indx = indx+1;
    end
end