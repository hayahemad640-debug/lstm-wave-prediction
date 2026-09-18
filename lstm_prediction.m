number_of_sequence = 1000;
sequence_lenght = 100;
time = linspace(0, 2*pi, sequence_lenght);
XTrain = cell(number_of_sequence, 1);
YTrain = cell(number_of_sequence, 1);

for i = 1:number_of_sequence
    amplitude = rand();
    frequncy = 1 + 4*rand();
    phase = 2*pi*rand();
    if rand() > 0.5
        wave = amplitude * sin(frequncy*time + phase);
    else
        wave = amplitude * cos(frequncy*time + phase);
    end
    XTrain{i} = wave(1:end-1);
    YTrain{i} = wave(2:end);
end

number_features = 1;
number_responses = 1;
number_hiddenUnites = 100;
layers = [
    sequenceInputLayer(number_features)
    lstmLayer(number_hiddenUnites)
    fullyConnectedLayer(number_responses)
    regressionLayer
];

options = trainingOptions('adam', ...
    'MaxEpochs', 10, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', 0.005, ...
    'Verbose', 0, ...
    'Plots', 'training-progress');

net = trainNetwork(XTrain, YTrain, layers, options);

test_amlitude = 1;
test_frequency = 2;
test_phase = pi/4;
test_wave = test_amlitude + sin(test_frequency*time + test_phase);
XTest = test_wave(1:end-1);
YTest = test_wave(2:end);
YPred = predict(net, XTest);

figure
plot(YTest, 'b')
hold on
plot(YPred, 'r--')
legend('Actual Wave', 'Predicted Wave')
xlabel('Time Step')
ylabel('Wave Value')
title('LSTM Prediction Of Tested Wave')
grid on
