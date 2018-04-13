function ratio = robustness(n,m)
if ~exist('m','var') || isempty(m)
    m=5;
end
arFitLHS(m-1);
count=zeros(n,1);
for i=1:n
    count(i)=arIdentifiablityTest(false,1,m,false);
    set(gcf,'visible','off');
end
ratio=sum(count)/n;
end