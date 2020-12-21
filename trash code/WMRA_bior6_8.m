
function [cD1,cD2,cD3,cD4,cD5,cD6,cD7,cD8] = WMRA_bior6_8(X, show)
    
    % Get wavelet
    [LoD,HiD,~,~] = wfilters('bior6.8');

    % level 1
    cD1 = filter(HiD,1,X);
    cD1 = downsample(cD1,2);
    LP1 = filter(LoD,1,X);
    LP1 = downsample(LP1,2);
    % level 2
    cD2 = filter(HiD,1,LP1);
    cD2 = downsample(cD2,2);
    LP2 = filter(LoD,1,LP1);
    LP2 = downsample(LP2,2);
    % level 3
    cD3 = filter(HiD,1,LP2);
    cD3 = downsample(cD3,2);
    LP3 = filter(LoD,1,LP2);
    LP3 = downsample(LP3,2);
    % level 4
    cD4 = filter(HiD,1,LP3);
    cD4 = downsample(cD4,2);
    LP4 = filter(LoD,1,LP3);
    LP4 = downsample(LP4,2);
    % level 5
    cD5 = filter(HiD,1,LP4);
    cD5 = downsample(cD5,2);
    LP5 = filter(LoD,1,LP4);
    LP5 = downsample(LP5,2);
    % level 6
    cD6 = filter(HiD,1,LP5);
    cD6 = downsample(cD6,2);
    LP6 = filter(LoD,1,LP5);
    LP6 = downsample(LP6,2);
    % level 7
    cD7 = filter(HiD,1,LP6);
    cD7 = downsample(cD7,2);
    LP7 = filter(LoD,1,LP6);
    LP7 = downsample(LP7,2);
    % level 8
    cD8 = filter(HiD,1,LP7);
    cD8 = downsample(cD8,2);
    LP8 = filter(LoD,1,LP7);
    LP8 = downsample(LP8,2);
    
    % plot input vs WRMA
    if show
        figure(); subplot(5,2,1); plot(X, 'k'); title('input')
        subplot(5,2,2); hold on;
        plot([1:126], cD1, 'k'); 
        plot([127:189], cD2, 'g');
        plot([190:221], cD3, 'r');
        plot([222:237], cD4, 'c');
        plot([238:245], cD5, 'm');
        plot([246:249], cD6, 'b');
        plot([250:251], cD7, 'g');
        plot([252],cD8, 'r');
        legend('cD1','cD2','cD3','cD4','cD5','cD6','cD7','cD8');
        title('WRMA'); hold off;
        subplot(5,2,3); plot(cD1, 'k'); title('cD1')
        subplot(5,2,4); plot(cD2, 'g'); title('cD2')
        subplot(5,2,5); plot(cD3, 'r'); title('cD3')
        subplot(5,2,6); plot(cD4, 'c'); title('cD4')
        subplot(5,2,7); plot(cD5, 'm'); title('cD5')
        subplot(5,2,8); plot(cD6, 'b'); title('cD6')
        subplot(5,2,9); plot(cD7, 'g'); title('cD7')
        subplot(5,2,10); plot(cD8, 'r'); title('cD8')
    end
    
end


