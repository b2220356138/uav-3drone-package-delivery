function msg = AlphaSendMessageToBeta(BetaUAV)
% AlphaSendMessageToBeta
% Struct-level communication placeholder.
% Can later be replaced with GenerateBinaryMessage + modulation chain.

    msg.TargetID = BetaUAV.ID;
    msg.Command = "FOLLOW_ASSIGNED_PATH";
    msg.Timestamp = datetime("now");
end
