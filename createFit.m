function [fitresult, gof] = createFit(x, y)

[xData, yData] = prepareCurveData( x, y );

ft = 'pchipinterp';

[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );
