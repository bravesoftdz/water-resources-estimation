function CCEUA(cdsEntrada, cdsParameter, cdsParameters_Distribuido, cdsResults, cdsResults_Lambda, cdsResults_Kb, cdsResults_Kss, cdsResults_Kcr : TClientDataSet; strP5 : TStringGrid; Hydrograph, graphAmin, graphAmax, graphAmed, graphKs, graphP : TChart; a, b: Double; bl_L, bu_L, bl_DT, bu_DT : Array of Double) : Double;
Var
  n, m : Integer;
  Cont_m1, Cont_m2, Cont_m3, Cont_m4, Cont_m5,
  Cont_m6, Cont_n, I, J, ibound, Contador_Random : Integer;
  Valor : Double;
  Label Fim;
Begin
    n := nps;
    m := nopt_L;
    // Assing the best and worst points
    sb_L := nil;
    sw_L := nil;
    snew_L := nil;
    SetLength (sb_L, m);
    SetLength (sw_L, m);
    SetLength (snew_L, m);

    If Calibrate_Lambda_DT = True Then
       Begin
           sb_Lambda := nil;
           sw_Lambda := nil;
           snew_Lambda := nil;
           SetLength (sb_Lambda, Number_subwatersheds);
           SetLength (sw_Lambda, Number_subwatersheds);
           SetLength (snew_Lambda, Number_subwatersheds);
       End;
    If Calibrate_Kb_DT = True Then
       Begin
           sb_Kb := nil;
           sw_Kb := nil;
           snew_Kb := nil;
           SetLength (sb_Kb, Number_subwatersheds);
           SetLength (sw_Kb, Number_subwatersheds);
           SetLength (snew_Kb, Number_subwatersheds);
       End;
    If Calibrate_Kss_DT = True Then
       Begin
           sb_Kss := nil;
           sw_Kss := nil;
           snew_Kss := nil;
           SetLength (sb_Kss, Number_subwatersheds);
           SetLength (sw_Kss, Number_subwatersheds);
           SetLength (snew_Kss, Number_subwatersheds);
       End;
    If Calibrate_Kcap_DT = True Then
       Begin
           sb_Kcr := nil;
           sw_Kcr := nil;
           snew_Kcr := nil;
           SetLength (sb_Kcr, Number_subwatersheds);
           SetLength (sw_Kcr, Number_subwatersheds);
           SetLength (snew_Kcr, Number_subwatersheds);
       End;

    For Cont_m1 := 1 to m do
       Begin
           sb_L [Cont_m1 - 1] := s_L [0 , (Cont_m1 - 1)];
           sw_L [Cont_m1 - 1] := s_L [(n - 1), (Cont_m1 - 1)];
       End;

    fb_L := sf_L [0];
    fw_L := sf_L [n - 1];

    For Cont_m1 := 1 to Number_subwatersheds do
       Begin
           If Calibrate_Lambda_DT = True Then
              Begin
                  sb_Lambda [Cont_m1 - 1] := s_Lambda [0 , (Cont_m1 - 1)];
                  sw_Lambda [Cont_m1 - 1] := s_Lambda [(n - 1), (Cont_m1 - 1)];
              End;
           If Calibrate_Kb_DT = True Then
              Begin
                  sb_Kb [Cont_m1 - 1] := s_Kb [0 , (Cont_m1 - 1)];
                  sw_Kb [Cont_m1 - 1] := s_Kb [(n - 1), (Cont_m1 - 1)];
              End;
           If Calibrate_Kss_DT = True Then
              Begin
                  sb_Kss [Cont_m1 - 1] := s_Kss [0 , (Cont_m1 - 1)];
                  sw_Kss [Cont_m1 - 1] := s_Kss [(n - 1), (Cont_m1 - 1)];
              End;
           If Calibrate_Kcap_DT = True Then
              Begin
                  sb_Kcr [Cont_m1 - 1] := s_Kcr [0 , (Cont_m1 - 1)];
                  sw_Kcr [Cont_m1 - 1] := s_Kcr [(n - 1), (Cont_m1 - 1)];
              End;
       End;

    If Calibrate_Lambda_DT = True Then
       Begin
           fb_Lambda := sf_Lambda [0];
           fw_Lambda := sf_Lambda [n - 1];
       End;
    If Calibrate_Kb_DT = True Then
       Begin
           fb_Kb := sf_Kb [0];
           fw_Kb := sf_Kb [n - 1];
       End;
    If Calibrate_Kss_DT = True Then
       Begin
           fb_Kss := sf_Kss [0];
           fw_Kss := sf_Kss [n - 1];
       End;
    If Calibrate_Kcap_DT = True Then
       Begin
           fb_Kcr := sf_Kcr [0];
           fw_Kcr := sf_Kcr [n - 1];
       End;
    // Assing the best and worst points

    // Compute the centroid of the simplex excluding the worst point
    ce_L := nil;
    Setlength (ce_L, m);

    If Calibrate_Lambda_DT = True Then
       Begin
           ce_Lambda := nil;
           SetLength (ce_Lambda, Number_subwatersheds);
       End;
    If Calibrate_Kb_DT = True Then
       Begin
           ce_Kb := nil;
           SetLength (ce_Kb, Number_subwatersheds);
       End;
    If Calibrate_Kss_DT = True Then
       Begin
           ce_Kss := nil;
           SetLength (ce_Kss, Number_subwatersheds);
       End;
    If Calibrate_Kcap_DT = True Then
       Begin
           ce_Kcr := nil;
           SetLength (ce_Kcr, Number_subwatersheds);
       End;
    
    For Cont_m2 := 1 to m do
       Begin
           Valor := 0;
           For Cont_n := 1 to (n - 1) do
              Valor := Valor + s_L [(Cont_n - 1), (Cont_m2 - 1)];
           ce_L [Cont_m2 - 1] := Valor / (n - 1);
       End;

    If Calibrate_Lambda_DT = True Then
       Begin
           For Cont_m2 := 1 to Number_subwatersheds do
              Begin
                  Valor := 0;
                  For Cont_n := 1 to (n - 1) do
                     Valor := Valor + s_Lambda [(Cont_n - 1), (Cont_m2 - 1)];
                  ce_Lambda [Cont_m2 - 1] := Valor / (n - 1);
              End;
       End;
    If Calibrate_Kb_DT = True Then
       Begin
           For Cont_m2 := 1 to Number_subwatersheds do
              Begin
                  Valor := 0;
                  For Cont_n := 1 to (n - 1) do
                     Valor := Valor + s_Kb [(Cont_n - 1), (Cont_m2 - 1)];
                  ce_Kb [Cont_m2 - 1] := Valor / (n - 1);
              End;
       End;
    If Calibrate_Kss_DT = True Then
       Begin
           For Cont_m2 := 1 to Number_subwatersheds do
              Begin
                  Valor := 0;
                  For Cont_n := 1 to (n - 1) do
                     Valor := Valor + s_Kss [(Cont_n - 1), (Cont_m2 - 1)];
                  ce_Kss [Cont_m2 - 1] := Valor / (n - 1);
              End;
       End;
    If Calibrate_Kcap_DT = True Then
       Begin
           For Cont_m2 := 1 to Number_subwatersheds do
              Begin
                  Valor := 0;
                  For Cont_n := 1 to (n - 1) do
                     Valor := Valor + s_Kcr [(Cont_n - 1), (Cont_m2 - 1)];
                  ce_Kcr [Cont_m2 - 1] := Valor / (n - 1);
              End;
       End;
    // Compute the centroid of the simplex excluding the worst point

    // Attempt a reflection point
    For Cont_m3 := 1 to m do
       snew_L [Cont_m3 - 1] := ce_L [Cont_m3 - 1] + a * (ce_L [Cont_m3 - 1] - sw_L [Cont_m3 - 1]);

    For Cont_m3 := 1 to Number_subwatersheds do
       Begin
           If Calibrate_Lambda_DT = True Then snew_Lambda [Cont_m3 - 1] := ce_Lambda [Cont_m3 - 1] + a * (ce_Lambda [Cont_m3 - 1] - sw_Lambda [Cont_m3 - 1]);
           If Calibrate_Kb_DT = True Then snew_Kb [Cont_m3 - 1] := ce_Kb [Cont_m3 - 1] + a * (ce_Kb [Cont_m3 - 1] - sw_Kb [Cont_m3 - 1]);
           If Calibrate_Kss_DT = True Then snew_Kss [Cont_m3 - 1] := ce_Kss [Cont_m3 - 1] + a * (ce_Kss [Cont_m3 - 1] - sw_Kss [Cont_m3 - 1]);
           If Calibrate_Kcap_DT = True Then snew_Kcr [Cont_m3 - 1] := ce_Kcr [Cont_m3 - 1] + a * (ce_Kcr [Cont_m3 - 1] - sw_Kcr [Cont_m3 - 1]);
       End;

    // Attempt a reflection point

    // Check if is outside the bounds
    ibound  := 0;
    s1_L := nil;
    SetLength (s1_L, m);
    s2_L := nil;
    SetLength (s2_L, m);
    Parameters_New_L := nil;
    SetLength (Parameters_New_L, m);

    If Calibrate_Lambda_DT = True Then
       Begin
           s1_Lambda := nil;
           SetLength (s1_Lambda, Number_subwatersheds);
           s2_Lambda := nil;
           SetLength (s2_Lambda, Number_subwatersheds);
           Parameters_New_Lambda := nil;
           SetLength (Parameters_New_Lambda, Number_subwatersheds);
       End;
    If Calibrate_Kb_DT = True Then
       Begin
           s1_Kb := nil;
           SetLength (s1_Kb, Number_subwatersheds);
           s2_Kb := nil;
           SetLength (s2_Kb, Number_subwatersheds);
           Parameters_New_Kb := nil;
           SetLength (Parameters_New_Kb, Number_subwatersheds);
       End;
    If Calibrate_Kss_DT = True Then
       Begin
           s1_Kss := nil;
           SetLength (s1_Kss, Number_subwatersheds);
           s2_Kss := nil;
           SetLength (s2_Kss, Number_subwatersheds);
           Parameters_New_Kss := nil;
           SetLength (Parameters_New_Kss, Number_subwatersheds);
       End;
    If Calibrate_Kcap_DT = True Then
       Begin
           s1_Kcr := nil;
           SetLength (s1_Kcr, Number_subwatersheds);
           s2_Kcr := nil;
           SetLength (s2_Kcr, Number_subwatersheds);
           Parameters_New_Kcr := nil;
           SetLength (Parameters_New_Kcr, Number_subwatersheds);
       End;

    Randomize;

    cdsResults.Append;
    For Cont_m4 := 1 to m do
       Begin
           s1_L [Cont_m4 - 1] := snew_L [Cont_m4 - 1] - bl_L [Cont_m4 - 1];
           s2_L [Cont_m4 - 1] := bu_L [Cont_m4 - 1] - snew_L [Cont_m4 - 1];
           If ((s1_L [Cont_m4 - 1] < 0) or (s2_L [Cont_m4 - 1] < 0)) Then
              snew_L [Cont_m4 - 1] := bl_L [Cont_m4 - 1] + (Random * (bu_L [Cont_m4 - 1] - bl_L [Cont_m4 - 1]));

           cdsResults.Fields [Cont_m4].Value := formatfloat('###,###,##0.0000', snew_L [Cont_m4 - 1]);
       End;
    If Calibrate_Lambda_DT = True Then
       Begin
           cdsResults_Lambda.Append;
           For Cont_m4 := 1 to Number_subwatersheds do
              Begin
                  If cdsParameters_Distribuido.Locate('Parameter', 'Lambda', [loCaseInsensitive]) = True Then
                     Begin
                         s1_Lambda [Cont_m4 - 1] := snew_Lambda [Cont_m4 - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1];
                         s2_Lambda [Cont_m4 - 1] := bu_DT [cdsParameters_Distribuido.RecNo - 1] - snew_Lambda [Cont_m4 - 1];
                         If ((s1_Lambda [Cont_m4 - 1] < 0) or (s2_Lambda [Cont_m4 - 1] < 0)) Then
                            snew_Lambda [Cont_m4 - 1] := bl_DT [cdsParameters_Distribuido.RecNo - 1] + (Random * (bu_DT [cdsParameters_Distribuido.RecNo - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1]));
                         cdsResults_Lambda.Fields [Cont_m4].Value := formatfloat('###,###,##0.0000', snew_Lambda [Cont_m4 - 1]);
                     End;
              End;
       End;
    If Calibrate_Kb_DT = True Then
       Begin
           cdsResults_Kb.Append;
           For Cont_m4 := 1 to Number_subwatersheds do
              Begin
                  If cdsParameters_Distribuido.Locate('Parameter', 'Kb', [loCaseInsensitive]) = True Then
                     Begin
                         s1_Kb [Cont_m4 - 1] := snew_Kb [Cont_m4 - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1];
                         s2_Kb [Cont_m4 - 1] := bu_DT [cdsParameters_Distribuido.RecNo - 1] - snew_Kb [Cont_m4 - 1];
                         If ((s1_Kb [Cont_m4 - 1] < 0) or (s2_Kb [Cont_m4 - 1] < 0)) Then
                            snew_Kb [Cont_m4 - 1] := bl_DT [cdsParameters_Distribuido.RecNo - 1] + (Random * (bu_DT [cdsParameters_Distribuido.RecNo - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1]));
                         cdsResults_Kb.Fields [Cont_m4].Value := formatfloat('###,###,##0.0000', snew_Kb [Cont_m4 - 1]);
                     End;
              End;
       End;
    If Calibrate_Kss_DT = True Then
       Begin
           cdsResults_Kss.Append;
           For Cont_m4 := 1 to Number_subwatersheds do
              Begin
                  If cdsParameters_Distribuido.Locate('Parameter', 'Kss', [loCaseInsensitive]) = True Then
                     Begin
                         s1_Kss [Cont_m4 - 1] := snew_Kss [Cont_m4 - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1];
                         s2_Kss [Cont_m4 - 1] := bu_DT [cdsParameters_Distribuido.RecNo - 1] - snew_Kss [Cont_m4 - 1];
                         If ((s1_Kss [Cont_m4 - 1] < 0) or (s2_Kss [Cont_m4 - 1] < 0)) Then
                            snew_Kss [Cont_m4 - 1] := bl_DT [cdsParameters_Distribuido.RecNo - 1] + (Random * (bu_DT [cdsParameters_Distribuido.RecNo - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1]));
                         cdsResults_Kss.Fields [Cont_m4].Value := formatfloat('###,###,##0.0000', snew_Kss [Cont_m4 - 1]);
                     End;
              End;
       End;
    If Calibrate_Kcap_DT = True Then
       Begin
           cdsResults_Kcr.Append;
           For Cont_m4 := 1 to Number_subwatersheds do
              Begin
                  If cdsParameters_Distribuido.Locate('Parameter', 'Kcap', [loCaseInsensitive]) = True Then
                     Begin
                         s1_Kcr [Cont_m4 - 1] := snew_Kcr [Cont_m4 - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1];
                         s2_Kcr [Cont_m4 - 1] := bu_DT [cdsParameters_Distribuido.RecNo - 1] - snew_Kcr [Cont_m4 - 1];
                         If ((s1_Kcr [Cont_m4 - 1] < 0) or (s2_Kcr [Cont_m4 - 1] < 0)) Then
                            snew_Kcr [Cont_m4 - 1] := bl_DT [cdsParameters_Distribuido.RecNo - 1] + (Random * (bu_DT [cdsParameters_Distribuido.RecNo - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1]));
                         cdsResults_Kcr.Fields [Cont_m4].Value := formatfloat('###,###,##0.0000', snew_Kcr [Cont_m4 - 1]);
                     End;
              End;
       End;

    If cdsParameter.Locate('Parameter', 'IVSMC', [loCaseInsensitive]) = True Then
       Percentage_Am := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'Kb', [loCaseInsensitive]) = True Then
       Kb := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'Kss', [loCaseInsensitive]) = True Then
       Kss := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'Kcap', [loCaseInsensitive]) = True Then
       Kcap := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'Lambda', [loCaseInsensitive]) = True Then
       Lambda := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'Cs', [loCaseInsensitive]) = True Then
       Cs := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'Css', [loCaseInsensitive]) = True Then
       Css := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'Cbase', [loCaseInsensitive]) = True Then
       Cbase := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'Ac', [loCaseInsensitive]) = True Then
       Ac := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'Acc', [loCaseInsensitive]) = True Then
       Acc := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'Acr', [loCaseInsensitive]) = True Then
       Acr := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'AL', [loCaseInsensitive]) = True Then
       AL := snew_L [cdsParameter.RecNo - 1];
    If cdsParameter.Locate('Parameter', 'PS', [loCaseInsensitive]) = True Then
       Pr := snew_L [cdsParameter.RecNo - 1];

    //ShowMessage('CCEE, reflection point');
    icall := icall + 1;

//## BH #############################################################################################################
    BH(cdsEntrada, cdsResults_Lambda, cdsResults_Kb, cdsResults_Kss, cdsResults_Kcr, strP5, Hydrograph, graphAmin, graphAmax, graphAmed, graphKs, graphP, End_Time, Timestep);
//## BH #############################################################################################################

    cdsResults.Edit;
    cdsResults.Fields [0].Value := icall;
    cdsResults.Fields [14].Value := formatfloat('###,###,##0.0000', RMSE);
    cdsResults.Fields [15].Value := formatfloat('###,###,##0.0000', Nash);
    cdsResults.Fields [16].Value := formatfloat('###,###,##0.0000', Nash_log);
    cdsResults.Fields [17].Value := formatfloat('###,###,##0.0000', DeltaV);
    cdsResults.UpdateRecord;

    If Calibrate_Lambda_DT = True Then
       Begin
           cdsResults_Lambda.Edit;
           cdsResults_Lambda.Fields [0].Value := icall;
           cdsResults_Lambda.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
           cdsResults_Lambda.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
           cdsResults_Lambda.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
           cdsResults_Lambda.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
           cdsResults_Lambda.UpdateRecord;
       End;
    If Calibrate_Kb_DT = True Then
       Begin
           cdsResults_Kb.Edit;
           cdsResults_Kb.Fields [0].Value := icall;
           cdsResults_Kb.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
           cdsResults_Kb.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
           cdsResults_Kb.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
           cdsResults_Kb.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
           cdsResults_Kb.UpdateRecord;
       End;
    If Calibrate_Kss_DT = True Then
       Begin
           cdsResults_Kss.Edit;
           cdsResults_Kss.Fields [0].Value := icall;
           cdsResults_Kss.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
           cdsResults_Kss.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
           cdsResults_Kss.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
           cdsResults_Kss.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
           cdsResults_Kss.UpdateRecord;
       End;
    If Calibrate_Kcap_DT = True Then
       Begin
           cdsResults_Kcr.Edit;
           cdsResults_Kcr.Fields [0].Value := icall;
           cdsResults_Kcr.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
           cdsResults_Kcr.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
           cdsResults_Kcr.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
           cdsResults_Kcr.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
           cdsResults_Kcr.UpdateRecord;
       End;

    fnew_L := Objective_Function;
    If Calibrate_Lambda_DT = True Then fnew_Lambda := Objective_Function;
    If Calibrate_Kb_DT = True Then fnew_Kb := Objective_Function;
    If Calibrate_Kss_DT = True Then fnew_Kss := Objective_Function;
    If Calibrate_Kcap_DT = True Then fnew_Kcr := Objective_Function;

    L := L + 1;
    If Encerrar = 1 Then
       goto Fim;
    // Check if is outside the bounds

    //Reflection failed; now attempt a contraction point
    If fnew_L > fw_L Then
       Begin
           snew_L := nil;
           Setlength(snew_L, m);

           If Calibrate_Lambda_DT = True Then
              Begin
                  snew_Lambda := nil;
                  SetLength (snew_Lambda, Number_subwatersheds);
              End;
           If Calibrate_Kb_DT = True Then
              Begin
                  snew_Kb := nil;
                  SetLength (snew_Kb, Number_subwatersheds);
              End;
           If Calibrate_Kss_DT = True Then
              Begin
                  snew_Kss := nil;
                  SetLength (snew_Kss, Number_subwatersheds);
              End;
           If Calibrate_Kcap_DT = True Then
              Begin
                  snew_Kcr := nil;
                  SetLength (snew_Kcr, Number_subwatersheds);
              End;

           //ShowMessage('Reflection failed; now attempt a contraction point!');
           cdsResults.Append;
           For Cont_m5 := 1 to m do
              Begin
                  snew_L [Cont_m5 - 1] := sw_L [Cont_m5 - 1] + b * (ce_L [Cont_m5 - 1] - sw_L [Cont_m5 - 1]);
                  cdsResults.Fields [Cont_m5].Value := formatfloat('###,###,##0.0000', snew_L [Cont_m5 - 1]);
              End;

           If Calibrate_Lambda_DT = True Then cdsResults_Lambda.Append;
           If Calibrate_Kb_DT = True Then cdsResults_Kb.Append;
           If Calibrate_Kss_DT = True Then cdsResults_Kss.Append;
           If Calibrate_Kcap_DT = True Then cdsResults_Kcr.Append;
           For Cont_m5 := 1 to Number_subwatersheds do
              Begin
                  If Calibrate_Lambda_DT = True Then
                     Begin
                         snew_Lambda [Cont_m5 - 1] := sw_Lambda [Cont_m5 - 1] + b * (ce_Lambda [Cont_m5 - 1] - sw_Lambda [Cont_m5 - 1]);
                         cdsResults_Lambda.Fields [Cont_m5].Value := formatfloat('###,###,##0.0000', snew_Lambda [Cont_m5 - 1]);
                     End;
                  If Calibrate_Kb_DT = True Then
                     Begin
                         snew_Kb [Cont_m5 - 1] := sw_Kb [Cont_m5 - 1] + b * (ce_Kb [Cont_m5 - 1] - sw_Kb [Cont_m5 - 1]);
                         cdsResults_Kb.Fields [Cont_m5].Value := formatfloat('###,###,##0.0000', snew_Kb [Cont_m5 - 1]);
                     End;
                  If Calibrate_Kss_DT = True Then
                     Begin
                         snew_Kss [Cont_m5 - 1] := sw_Kss [Cont_m5 - 1] + b * (ce_Kss [Cont_m5 - 1] - sw_Kss [Cont_m5 - 1]);
                         cdsResults_Kss.Fields [Cont_m5].Value := formatfloat('###,###,##0.0000', snew_Kss [Cont_m5 - 1]);
                     End;
                  If Calibrate_Kcap_DT = True Then
                     Begin
                         snew_Kcr [Cont_m5 - 1] := sw_Kcr [Cont_m5 - 1] + b * (ce_Kcr [Cont_m5 - 1] - sw_Kcr [Cont_m5 - 1]);
                         cdsResults_Kcr.Fields [Cont_m5].Value := formatfloat('###,###,##0.0000', snew_Kcr [Cont_m5 - 1]);
                     End;
              End;

           If cdsParameter.Locate('Parameter', 'IVSMC', [loCaseInsensitive]) = True Then
              Percentage_Am := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'Kb', [loCaseInsensitive]) = True Then
              Kb := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'Kss', [loCaseInsensitive]) = True Then
              Kss := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'Kcap', [loCaseInsensitive]) = True Then
              Kcap := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'Lambda', [loCaseInsensitive]) = True Then
              Lambda := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'Cs', [loCaseInsensitive]) = True Then
              Cs := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'Css', [loCaseInsensitive]) = True Then
              Css := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'Cbase', [loCaseInsensitive]) = True Then
              Cbase := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'Ac', [loCaseInsensitive]) = True Then
              Ac := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'Acc', [loCaseInsensitive]) = True Then
              Acc := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'Acr', [loCaseInsensitive]) = True Then
              Acr := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'AL', [loCaseInsensitive]) = True Then
              AL := snew_L [cdsParameter.RecNo - 1];
           If cdsParameter.Locate('Parameter', 'PS', [loCaseInsensitive]) = True Then
              Pr := snew_L [cdsParameter.RecNo - 1];

           //ShowMessage('CCEE, contraction point');
           icall := icall + 1;

//## BH #############################################################################################################
           BH(cdsEntrada, cdsResults_Lambda, cdsResults_Kb, cdsResults_Kss, cdsResults_Kcr, strP5, Hydrograph, graphAmin, graphAmax, graphAmed, graphKs, graphP, End_Time, Timestep);
//## BH #############################################################################################################

           cdsResults.Edit;
           cdsResults.Fields [0].Value := icall;
           cdsResults.Fields [14].Value := formatfloat('###,###,##0.0000', RMSE);
           cdsResults.Fields [15].Value := formatfloat('###,###,##0.0000', Nash);
           cdsResults.Fields [16].Value := formatfloat('###,###,##0.0000', Nash_log);
           cdsResults.Fields [17].Value := formatfloat('###,###,##0.0000', DeltaV);
           cdsResults.UpdateRecord;

           If Calibrate_Lambda_DT = True Then
              Begin
                  cdsResults_Lambda.Edit;
                  cdsResults_Lambda.Fields [0].Value := icall;
                  cdsResults_Lambda.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                  cdsResults_Lambda.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                  cdsResults_Lambda.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                  cdsResults_Lambda.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
                  cdsResults_Lambda.UpdateRecord;
              End;
           If Calibrate_Kb_DT = True Then
              Begin
                  cdsResults_Kb.Edit;
                  cdsResults_Kb.Fields [0].Value := icall;
                  cdsResults_Kb.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                  cdsResults_Kb.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                  cdsResults_Kb.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                  cdsResults_Kb.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
                  cdsResults_Kb.UpdateRecord;
              End;
           If Calibrate_Kss_DT = True Then
              Begin
                  cdsResults_Kss.Edit;
                  cdsResults_Kss.Fields [0].Value := icall;
                  cdsResults_Kss.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                  cdsResults_Kss.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                  cdsResults_Kss.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                  cdsResults_Kss.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
                  cdsResults_Kss.UpdateRecord;
              End;
           If Calibrate_Kcap_DT = True Then
              Begin
                  cdsResults_Kcr.Edit;
                  cdsResults_Kcr.Fields [0].Value := icall;
                  cdsResults_Kcr.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                  cdsResults_Kcr.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                  cdsResults_Kcr.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                  cdsResults_Kcr.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
                  cdsResults_Kcr.UpdateRecord;
              End;


           fnew_L := Objective_Function;
           If Calibrate_Lambda_DT = True Then fnew_Lambda := Objective_Function;
           If Calibrate_Kb_DT = True Then fnew_Kb := Objective_Function;
           If Calibrate_Kss_DT = True Then fnew_Kss := Objective_Function;
           If Calibrate_Kcap_DT = True Then fnew_Kcr := Objective_Function;

           L := L + 1;
           If Encerrar = 1 Then
              goto Fim;
    //Reflection failed; now attempt a contraction point
           // Both reflection and contraction have failed, attempt a random point
           Contador_Random := 0;
           If fnew_L > fw_L Then
             Begin
                 Inc (Contador_Random, 1);
                 snew_L := nil;
                 Setlength (snew_L, m);

                 If Calibrate_Lambda_DT = True Then
                    Begin
                        snew_Lambda := nil;
                        SetLength (snew_Lambda, Number_subwatersheds);
                    End;
                 If Calibrate_Kb_DT = True Then
                    Begin
                        snew_Kb := nil;
                        SetLength (snew_Kb, Number_subwatersheds);
                    End;
                 If Calibrate_Kss_DT = True Then
                    Begin
                        snew_Kss:= nil;
                        SetLength (snew_Kss, Number_subwatersheds);
                    End;
                 If Calibrate_Kcap_DT = True Then
                    Begin
                        snew_Kcr := nil;
                        SetLength (snew_Kcr, Number_subwatersheds);
                    End;

                 //ShowMessage('Random point!');
                 cdsResults.Append;
                 For Cont_m6 := 1 to m do
                    Begin
                        snew_L [Cont_m6 - 1] := bl_L [Cont_m6 - 1] + Random * (bu_L [Cont_m6 - 1] - bl_L [Cont_m6 - 1]);
                        cdsResults.Fields [Cont_m6].Value := formatfloat('###,###,##0.0000', snew_L [Cont_m6 - 1]);
                    End;

                 If Calibrate_Lambda_DT = True Then cdsResults_Lambda.Append;
                 If Calibrate_Kb_DT = True Then cdsResults_Kb.Append;
                 If Calibrate_Kss_DT = True Then cdsResults_Kss.Append;
                 If Calibrate_Kcap_DT = True Then cdsResults_Kcr.Append;
                 For Cont_m6 := 1 to Number_subwatersheds do
                    Begin
                        If cdsParameters_Distribuido.Locate('Parameter', 'Lambda', [loCaseInsensitive]) = True Then
                           Begin
                               snew_Lambda [Cont_m6 - 1] := bl_DT [cdsParameters_Distribuido.RecNo - 1] + Random * (bu_DT [cdsParameters_Distribuido.RecNo - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1]);
                               cdsResults_Lambda.Fields [Cont_m6].Value := formatfloat('###,###,##0.0000', snew_Lambda [Cont_m6 - 1]);
                           End;
                        If cdsParameters_Distribuido.Locate('Parameter', 'Kb', [loCaseInsensitive]) = True Then
                           Begin
                               snew_Kb [Cont_m6 - 1] := bl_DT [cdsParameters_Distribuido.RecNo - 1] + Random * (bu_DT [cdsParameters_Distribuido.RecNo - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1]);
                               cdsResults_Kb.Fields [Cont_m6].Value := formatfloat('###,###,##0.0000', snew_Kb [Cont_m6 - 1]);
                           End;
                        If cdsParameters_Distribuido.Locate('Parameter', 'Kss', [loCaseInsensitive]) = True Then
                           Begin
                               snew_Kss [Cont_m6 - 1] := bl_DT [cdsParameters_Distribuido.RecNo - 1] + Random * (bu_DT [cdsParameters_Distribuido.RecNo - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1]);
                               cdsResults_Kss.Fields [Cont_m6].Value := formatfloat('###,###,##0.0000', snew_Kss [Cont_m6 - 1]);
                           End;
                        If cdsParameters_Distribuido.Locate('Parameter', 'Kcap', [loCaseInsensitive]) = True Then
                           Begin
                               snew_Kcr [Cont_m6 - 1] := bl_DT [cdsParameters_Distribuido.RecNo - 1] + Random * (bu_DT [cdsParameters_Distribuido.RecNo - 1] - bl_DT [cdsParameters_Distribuido.RecNo - 1]);
                               cdsResults_Kcr.Fields [Cont_m6].Value := formatfloat('###,###,##0.0000', snew_Kcr [Cont_m6 - 1]);
                           End;
                    End;

                 If cdsParameter.Locate('Parameter', 'IVSMC', [loCaseInsensitive]) = True Then
                    Percentage_Am := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'Kb', [loCaseInsensitive]) = True Then
                    Kb := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'Kss', [loCaseInsensitive]) = True Then
                    Kss := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'Kcap', [loCaseInsensitive]) = True Then
                    Kcap := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'Lambda', [loCaseInsensitive]) = True Then
                    Lambda := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'Cs', [loCaseInsensitive]) = True Then
                    Cs := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'Css', [loCaseInsensitive]) = True Then
                    Css := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'Cbase', [loCaseInsensitive]) = True Then
                    Cbase := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'Ac', [loCaseInsensitive]) = True Then
                    Ac := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'Acc', [loCaseInsensitive]) = True Then
                    Acc := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'Acr', [loCaseInsensitive]) = True Then
                    Acr := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'AL', [loCaseInsensitive]) = True Then
                    AL := snew_L [cdsParameter.RecNo - 1];
                 If cdsParameter.Locate('Parameter', 'PS', [loCaseInsensitive]) = True Then
                    Pr := snew_L [cdsParameter.RecNo - 1];

                 //ShowMessage('CCEE, RANDOM point');
                 icall := icall + 1;

//## BH #############################################################################################################
                 BH(cdsEntrada, cdsResults_Lambda, cdsResults_Kb, cdsResults_Kss, cdsResults_Kcr, strP5, Hydrograph, graphAmin, graphAmax, graphAmed, graphKs, graphP, End_Time, Timestep);
//## BH #############################################################################################################

                 cdsResults.Edit;
                 cdsResults.Fields [0].Value := icall;
                 cdsResults.Fields [14].Value := formatfloat('###,###,##0.0000', RMSE);
                 cdsResults.Fields [15].Value := formatfloat('###,###,##0.0000', Nash);
                 cdsResults.Fields [16].Value := formatfloat('###,###,##0.0000', Nash_log);
                 cdsResults.Fields [17].Value := formatfloat('###,###,##0.0000', DeltaV);
                 cdsResults.UpdateRecord;

                 If Calibrate_Lambda_DT = True Then
                    Begin
                        cdsResults_Lambda.Edit;
                        cdsResults_Lambda.Fields [0].Value := icall;
                        cdsResults_Lambda.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                        cdsResults_Lambda.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                        cdsResults_Lambda.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                        cdsResults_Lambda.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
                        cdsResults_Lambda.UpdateRecord;
                    End;
                 If Calibrate_Kb_DT = True Then
                    Begin
                        cdsResults_Kb.Edit;
                        cdsResults_Kb.Fields [0].Value := icall;
                        cdsResults_Kb.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                        cdsResults_Kb.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                        cdsResults_Kb.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                        cdsResults_Kb.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
                        cdsResults_Kb.UpdateRecord;
                    End;
                 If Calibrate_Kss_DT = True Then
                    Begin
                        cdsResults_Kss.Edit;
                        cdsResults_Kss.Fields [0].Value := icall;
                        cdsResults_Kss.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                        cdsResults_Kss.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                        cdsResults_Kss.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                        cdsResults_Kss.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
                        cdsResults_Kss.UpdateRecord;
                    End;
                 If Calibrate_Kcap_DT = True Then
                    Begin
                        cdsResults_Kcr.Edit;
                        cdsResults_Kcr.Fields [0].Value := icall;
                        cdsResults_Kcr.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                        cdsResults_Kcr.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                        cdsResults_Kcr.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                        cdsResults_Kcr.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
                        cdsResults_Kcr.UpdateRecord;
                    End;


                 fnew_L := Objective_Function;
                 If Calibrate_Lambda_DT = True Then fnew_Lambda := Objective_Function;
                 If Calibrate_Kb_DT = True Then fnew_Kb := Objective_Function;
                 If Calibrate_Kss_DT = True Then fnew_Kss := Objective_Function;
                 If Calibrate_Kcap_DT = True Then fnew_Kcr := Objective_Function;
                 
                 L := L + 1;
                 If Encerrar = 1 Then
                    goto Fim;
             End;//If fnew > fw Then
    // Both reflection and contraction have failed, attempt a random point
       End;//If fnew > fw Then
    Fim:
       //ShowMessage('Reflection point!');
End;
//############################################## CCEUA - FIM #####################################################################
//################################################################################################################################

//############################################## SCE - INÍCIO ####################################################################
//################################################################################################################################
function SCE(cdsEntrada, cdsParameter, cdsParameters_Distribuido, cdsResults, cdsResults_Lambda, cdsResults_Kb, cdsResults_Kss, cdsResults_Kcr : TClientDataSet; strP5 : TStringGrid; Hydrograph, graphAmin, graphAmax, graphAmed, graphKs, graphP :TChart; maxn : Integer) : Double;
Var
   nspl, mings, npt : Integer;
   igs, k1, k2, k3, iter, lpos : Integer;
   Bound_L, Bound_DT : Array of Double;
   X_L, Xf_L, X_Lambda, Xf_Lambda, X_Kb, Xf_Kb, X_Kss, Xf_Kss, X_Kcr, Xf_Kcr : Array of Array of Double;
   BestX_L, WorstX_L, BestX_Lambda, WorstX_Lambda, BestX_Kb, WorstX_Kb, BestX_Kss, WorstX_Kss, BestX_Kcr, WorstX_Kcr : Array of Double;
   Bestf, Worstf, gnrng : Double;
   Matrix_Par1, Matrix_Par2, Matrix_Par3 : Array of Double;
   xnstd, Matrix_gnrng : Array of Double;
   cx_L, cf_L, cx_Lambda, cf_Lambda, cx_Kb, cf_Kb, cx_Kss, cf_Kss, cx_Kcr, cf_Kcr : Array of Array of Double;
   lcs : Array of Integer;
   Cont_Alpha_SCE, loop_nps1, loop_nps2,
   loop_nopt1, loop_nopt2, loop_nopt3, loop_nopt4,
   loop_nopt5, loop_nopt6, loop_nopt7, loop_nopt8,
   loop_nopt9, loop_nopt10, loop_nopt11,
   loop_nopt12, loop_nopt13, loop_nopt14, loop_npt1,
   loop_npt2, loop_npt3, loop_npt4, loop_npt5,
   loop_npt6, loop_npg1, loop_npg2 : Integer;
Begin
    L := 0; //contador para escrever o valor de RMSE na matriz
    icall := 0;
    nloop := 0;
    
    If npg = 0 Then  // number of members in a complex
       //npg := (2 * nopt) + 1
       npg := 59
    Else
       npg := npg;

    If nps = 0 Then  // number of members in a simplex
       //nps := nopt + 1
       nps := 30
    Else
       nps := nps;

    If pmin = 0 Then// minimum number of complexes required during the optimization process
       mings := ngs
    Else
       mings := pmin;

    If Beta = 0 Then// Beta --> number of evolution steps for each complex before shuffling
       //nspl := npg
       nspl := 59
    Else
       nspl := Beta;

    If Alpha_SCE = 0 Then // Alpha --> number of consecutive offspring generated by the same subcomplex
       Alpha_SCE := 1
    Else
       Alpha_SCE := Alpha_SCE;

    npt := npg * ngs;      // sample size

    Bound_L := nil;
    SetLength (Bound_L, nopt_L);

    Bound_DT := nil;
    SetLength (Bound_DT, nopt_DT);
    
    RMSE_matriz := nil;
    SetLength (RMSE_matriz, npt);

    For loop_nopt1 := 1 to nopt_L  do
       Bound_L [(loop_nopt1 - 1)] := bu_L [(loop_nopt1 - 1)] - bl_L [(loop_nopt1 - 1)];

    For loop_nopt1 := 1 to nopt_DT do
       Bound_DT [(loop_nopt1 - 1)] := bu_DT [(loop_nopt1 - 1)] - bl_DT [(loop_nopt1 - 1)];

    X_L := nil;
    SetLength (X_L, npt, nopt_L);
    Xf_L := nil;
    SetLength (Xf_L, npt, (nopt_L + 1));
    Parameters_L := nil;
    SetLength (Parameters_L, npt, nopt_L);

    If Calibrate_Lambda_DT = True Then
       Begin
           X_Lambda := nil;
           SetLength (X_Lambda, npt, Number_subwatersheds);
           Xf_Lambda := nil;
           SetLength (Xf_Lambda, npt, (Number_subwatersheds + 1));
           Parameters_Lambda := nil;
           SetLength (Parameters_Lambda, npt, Number_subwatersheds);
       End;

    If Calibrate_Kb_DT = True Then
       Begin
           X_Kb := nil;
           SetLength (X_Kb, npt, Number_subwatersheds);
           Xf_Kb := nil;
           SetLength (Xf_Kb, npt, (Number_subwatersheds + 1));
           Parameters_Kb := nil;
           SetLength (Parameters_Kb, npt, Number_subwatersheds);
       End;

    If Calibrate_Kss_DT = True Then
       Begin
           X_Kss := nil;
           SetLength (X_Kss, npt, Number_subwatersheds);
           Xf_Kss := nil;
           SetLength (Xf_Kss, npt, (Number_subwatersheds + 1));
           Parameters_Kss := nil;
           SetLength (Parameters_Kss, npt, Number_subwatersheds);
       End;

    If Calibrate_Kcap_DT = True Then
       Begin
           X_Kcr := nil;
           SetLength (X_Kcr, npt, Number_subwatersheds);
           Xf_Kcr := nil;
           SetLength (Xf_Kcr, npt, (Number_subwatersheds + 1));
           Parameters_Kcr := nil;
           SetLength (Parameters_Kcr, npt, Number_subwatersheds);
       End;

    Randomize;

    For loop_npt1 := 1 to npt do
       Begin
           cdsResults.Append;
           For loop_nopt2 := 1 to nopt_L do
             Begin
                 X_L [(loop_npt1 - 1), (loop_nopt2 - 1)] := bl_L [(loop_nopt2 - 1)] + random * Bound_L [(loop_nopt2 - 1)];
                 Xf_L [(loop_npt1 - 1), (loop_nopt2 - 1)] := X_L [(loop_npt1 - 1), (loop_nopt2 - 1)];
                 Parameters_L [(loop_npt1 - 1), (loop_nopt2 - 1)] := Xf_L [(loop_npt1 - 1), (loop_nopt2 - 1)];
                 cdsResults.Fields [loop_nopt2].Value := formatfloat('###,###,##0.0000', Parameters_L [(loop_npt1 - 1), (loop_nopt2 - 1)]);
             End;
           cdsResults.UpdateRecord;

           If Calibrate_Lambda_DT = True Then cdsResults_Lambda.Append;
           If Calibrate_Kb_DT = True Then cdsResults_Kb.Append;
           If Calibrate_Kss_DT = True Then cdsResults_Kss.Append;
           If Calibrate_Kcap_DT = True Then cdsResults_Kcr.Append;
           For loop_nopt2 := 1 to Number_subwatersheds do
             Begin
                 If cdsParameters_Distribuido.Locate('Parameter', 'Lambda', [loCaseInsensitive]) = True Then
                    Begin
                        X_Lambda [(loop_npt1 - 1), (loop_nopt2 - 1)] := bl_DT [(cdsParameters_Distribuido.RecNo - 1)] + random * Bound_DT [(cdsParameters_Distribuido.RecNo - 1)];
                        Xf_Lambda [(loop_npt1 - 1), (loop_nopt2 - 1)] := X_Lambda [(loop_npt1 - 1), (loop_nopt2 - 1)];
                        Parameters_Lambda [(loop_npt1 - 1), (loop_nopt2 - 1)] := Xf_Lambda [(loop_npt1 - 1), (loop_nopt2 - 1)];
                        cdsResults_Lambda.Fields [loop_nopt2].Value := formatfloat('###,###,##0.0000', Parameters_Lambda [(loop_npt1 - 1), (loop_nopt2 - 1)]);
                    End;
                 If cdsParameters_Distribuido.Locate('Parameter', 'Kb', [loCaseInsensitive]) = True Then
                    Begin
                        X_Kb [(loop_npt1 - 1), (loop_nopt2 - 1)] := bl_DT [(cdsParameters_Distribuido.RecNo - 1)] + random * Bound_DT [(cdsParameters_Distribuido.RecNo - 1)];
                        Xf_Kb [(loop_npt1 - 1), (loop_nopt2 - 1)] := X_Kb [(loop_npt1 - 1), (loop_nopt2 - 1)];
                        Parameters_Kb [(loop_npt1 - 1), (loop_nopt2 - 1)] := Xf_Kb [(loop_npt1 - 1), (loop_nopt2 - 1)];
                        cdsResults_Kb.Fields [loop_nopt2].Value := formatfloat('###,###,##0.0000', Parameters_Kb [(loop_npt1 - 1), (loop_nopt2 - 1)]);
                    End;
                 If cdsParameters_Distribuido.Locate('Parameter', 'Kss', [loCaseInsensitive]) = True Then
                    Begin
                        X_Kss [(loop_npt1 - 1), (loop_nopt2 - 1)] := bl_DT [(cdsParameters_Distribuido.RecNo - 1)] + random * Bound_DT [(cdsParameters_Distribuido.RecNo - 1)];
                        Xf_Kss [(loop_npt1 - 1), (loop_nopt2 - 1)] := X_Kss [(loop_npt1 - 1), (loop_nopt2 - 1)];
                        Parameters_Kss [(loop_npt1 - 1), (loop_nopt2 - 1)] := Xf_Kss [(loop_npt1 - 1), (loop_nopt2 - 1)];
                        cdsResults_Kss.Fields [loop_nopt2].Value := formatfloat('###,###,##0.0000', Parameters_Kss [(loop_npt1 - 1), (loop_nopt2 - 1)]);
                    End;
                 If cdsParameters_Distribuido.Locate('Parameter', 'Kcap', [loCaseInsensitive]) = True Then
                    Begin
                        X_Kcr [(loop_npt1 - 1), (loop_nopt2 - 1)] := bl_DT [(cdsParameters_Distribuido.RecNo - 1)] + random * Bound_DT [(cdsParameters_Distribuido.RecNo - 1)];
                        Xf_Kcr [(loop_npt1 - 1), (loop_nopt2 - 1)] := X_Kcr [(loop_npt1 - 1), (loop_nopt2 - 1)];
                        Parameters_Kcr [(loop_npt1 - 1), (loop_nopt2 - 1)] := Xf_Kcr [(loop_npt1 - 1), (loop_nopt2 - 1)];
                        cdsResults_Kcr.Fields [loop_nopt2].Value := formatfloat('###,###,##0.0000', Parameters_Kcr [(loop_npt1 - 1), (loop_nopt2 - 1)]);
                    End;
             End;
           If Calibrate_Lambda_DT = True Then cdsResults_Lambda.UpdateRecord;
           If Calibrate_Kb_DT = True Then cdsResults_Kb.UpdateRecord;
           If Calibrate_Kss_DT = True Then cdsResults_Kss.UpdateRecord;
           If Calibrate_Kcap_DT = True Then cdsResults_Kcr.UpdateRecord;
       End;

    {cdsResults.Edit;
    cdsResults.Refresh;}
    cdsResults.First;
    If Calibrate_Lambda_DT = True Then cdsResults_Lambda.First;
    If Calibrate_Kb_DT = True Then cdsResults_Kb.First;
    If Calibrate_Kss_DT = True Then cdsResults_Kss.First;
    If Calibrate_Kcap_DT = True Then cdsResults_Kcr.First;
    For loop_npt2 := 1 to npt do
       Begin
           If cdsParameter.Locate('Parameter', 'IVSMC', [loCaseInsensitive]) = True Then
              Percentage_Am := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'Kb', [loCaseInsensitive]) = True Then
              Kb := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'Kss', [loCaseInsensitive]) = True Then
              Kss := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'Kcap', [loCaseInsensitive]) = True Then
              Kcap := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'Lambda', [loCaseInsensitive]) = True Then
              Lambda := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'Cs', [loCaseInsensitive]) = True Then
              Cs := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'Css', [loCaseInsensitive]) = True Then
              Css := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'Cbase', [loCaseInsensitive]) = True Then
              Cbase := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'Ac', [loCaseInsensitive]) = True Then
              Ac := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'Acc', [loCaseInsensitive]) = True Then
              Acc := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'Acr', [loCaseInsensitive]) = True Then
              Acr := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'AL', [loCaseInsensitive]) = True Then
              AL := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           If cdsParameter.Locate('Parameter', 'PS', [loCaseInsensitive]) = True Then
              Pr := X_L [(loop_npt2 - 1), (cdsParameter.RecNo - 1)];
           {ShowMessage('Lambda =' + FloatToStr (Lambda));
           ShowMessage('Kb =' + FloatToStr (Kb));
           ShowMessage('Kss =' + FloatToStr (Kss));
           ShowMessage('Kcap =' + FloatToStr (Kcap));
           ShowMessage('Cs =' + FloatToStr (Cs));
           ShowMessage('Css =' + FloatToStr (Css));}
           icall := icall + 1;

           //ShowMessage ('Ate aqui nao deu erro!');
//## BH #############################################################################################################
           BH(cdsEntrada, cdsResults_Lambda, cdsResults_Kb, cdsResults_Kss, cdsResults_Kcr, strP5, Hydrograph, graphAmin, graphAmax, graphAmed, graphKs, graphP, End_Time, Timestep);
//## BH #############################################################################################################
           //ShowMessage ('Ate aqui nao deu erro!');

           cdsResults.Edit;
           cdsResults.Fields [0].Value := icall;
           cdsResults.Fields [14].Value := formatfloat('###,###,##0.0000', RMSE);
           cdsResults.Fields [15].Value := formatfloat('###,###,##0.0000', Nash);
           cdsResults.Fields [16].Value := formatfloat('###,###,##0.0000', Nash_log);
           cdsResults.Fields [17].Value := formatfloat('###,###,##0.0000', DeltaV);
           //cdsResults.Fields [18].Value := formatfloat('###,###,##0.0000', R2);

           If Calibrate_Lambda_DT = True Then
              Begin
                  cdsResults_Lambda.Edit;
                  cdsResults_Lambda.Fields [0].Value := icall;
                  cdsResults_Lambda.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                  cdsResults_Lambda.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                  cdsResults_Lambda.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                  cdsResults_Lambda.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
              End;

           If Calibrate_Kb_DT = True Then
              Begin
                  cdsResults_Kb.Edit;
                  cdsResults_Kb.Fields [0].Value := icall;
                  cdsResults_Kb.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                  cdsResults_Kb.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                  cdsResults_Kb.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                  cdsResults_Kb.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
              End;

           If Calibrate_Kss_DT = True Then
              Begin
                  cdsResults_Kss.Edit;
                  cdsResults_Kss.Fields [0].Value := icall;
                  cdsResults_Kss.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                  cdsResults_Kss.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                  cdsResults_Kss.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                  cdsResults_Kss.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
              End;

           If Calibrate_Kcap_DT = True Then
              Begin
                  cdsResults_Kcr.Edit;
                  cdsResults_Kcr.Fields [0].Value := icall;
                  cdsResults_Kcr.Fields [Number_subwatersheds + 1].Value := formatfloat('###,###,##0.0000', RMSE);
                  cdsResults_Kcr.Fields [Number_subwatersheds + 2].Value := formatfloat('###,###,##0.0000', Nash);
                  cdsResults_Kcr.Fields [Number_subwatersheds + 3].Value := formatfloat('###,###,##0.0000', Nash_log);
                  cdsResults_Kcr.Fields [Number_subwatersheds + 4].Value := formatfloat('###,###,##0.0000', DeltaV);
              End;

           Xf_L [(loop_npt2 - 1), nopt_L] := Objective_Function;
           If Calibrate_Lambda_DT = True Then Xf_Lambda [(loop_npt2 - 1), Number_subwatersheds] := Objective_Function;
           If Calibrate_Kb_DT = True Then Xf_Kb [(loop_npt2 - 1), Number_subwatersheds] := Objective_Function;
           If Calibrate_Kss_DT = True Then Xf_Kss [(loop_npt2 - 1), Number_subwatersheds] := Objective_Function;
           If Calibrate_Kcap_DT = True Then Xf_Kcr [(loop_npt2 - 1), Number_subwatersheds] := Objective_Function;

           cdsResults.UpdateRecord;
           If Calibrate_Lambda_DT = True Then cdsResults_Lambda.UpdateRecord;
           If Calibrate_Kb_DT = True Then cdsResults_Kb.UpdateRecord;
           If Calibrate_Kss_DT = True Then cdsResults_Kss.UpdateRecord;
           If Calibrate_Kcap_DT = True Then cdsResults_Kcr.UpdateRecord;

           //cdsResults.Refresh;
           cdsResults.Next;
           If Calibrate_Lambda_DT = True Then cdsResults_Lambda.Next;
           If Calibrate_Kb_DT = True Then cdsResults_Kb.Next;
           If Calibrate_Kss_DT = True Then cdsResults_Kss.Next;
           If Calibrate_Kcap_DT = True Then cdsResults_Kcr.Next;

           L := L + 1; // adiciona 1 linha na matriz de RMSE

           If Encerrar = 1 Then
              Break;
       End;//For loop_npt2 := 1 to npt do

    // Ordenar matriz Xf
    matriz_ordenar := nil;
    SetLength(matriz_ordenar, npt, (nopt_L + 1));

    For loop_npt3 := 1 to npt do
       Begin
           For loop_nopt3 := 1 to nopt_L do
              matriz_ordenar[(loop_npt3 - 1), (loop_nopt3 - 1)] := Xf_L [(loop_npt3 - 1), (loop_nopt3 - 1)];
           matriz_ordenar[(loop_npt3 - 1), nopt_L] := Xf_L [(loop_npt3 - 1), nopt_L];
       End;

    QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (nopt_L + 1), nopt_L);
    Xf_L := nil;
    SetLength (Xf_L, npt, (nopt_L + 1));

    For loop_npt4 := 1 to npt do
       For loop_nopt4 := 0 to nopt_L do
           Xf_L[(loop_npt4 - 1), loop_nopt4] := matriz_ordenar [(loop_npt4 - 1), loop_nopt4];
    // Ordenar matriz Xf

    // Ordenar matriz de Lambda
    If Calibrate_Lambda_DT = True Then
       Begin
           matriz_ordenar := nil;
           SetLength (matriz_ordenar, npt, (Number_subwatersheds + 1));
           For loop_npt3 := 1 to npt do
              Begin
                  For loop_nopt3 := 1 to Number_subwatersheds do
                     matriz_ordenar[(loop_npt3 - 1), (loop_nopt3 - 1)] := Xf_Lambda [(loop_npt3 - 1), (loop_nopt3 - 1)];
                  matriz_ordenar[(loop_npt3 - 1), Number_subwatersheds] := Xf_Lambda [(loop_npt3 - 1), Number_subwatersheds];
              End;
           QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
           Xf_Lambda := nil;
           SetLength (Xf_Lambda, npt, (Number_subwatersheds + 1));
           For loop_npt4 := 1 to npt do
              For loop_nopt4 := 0 to Number_subwatersheds do
                 Xf_Lambda[(loop_npt4 - 1), loop_nopt4] := matriz_ordenar [(loop_npt4 - 1), loop_nopt4];
       End;
    // Ordenar matriz de Lambda

    // Ordenar matriz de Kb
    If Calibrate_Kb_DT = True Then
       Begin
           matriz_ordenar := nil;
           SetLength (matriz_ordenar, npt, (Number_subwatersheds + 1));
           For loop_npt3 := 1 to npt do
              Begin
                  For loop_nopt3 := 1 to Number_subwatersheds do
                     matriz_ordenar[(loop_npt3 - 1), (loop_nopt3 - 1)] := Xf_Kb [(loop_npt3 - 1), (loop_nopt3 - 1)];
                  matriz_ordenar[(loop_npt3 - 1), Number_subwatersheds] := Xf_Kb [(loop_npt3 - 1), Number_subwatersheds];
              End;
           QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
           Xf_Kb := nil;
           SetLength (Xf_Kb, npt, (Number_subwatersheds + 1));
           For loop_npt4 := 1 to npt do
              For loop_nopt4 := 0 to Number_subwatersheds do
                 Xf_Kb[(loop_npt4 - 1), loop_nopt4] := matriz_ordenar [(loop_npt4 - 1), loop_nopt4];
       End;
    // Ordenar matriz de Kb

    // Ordenar matriz de Kss
    If Calibrate_Kss_DT = True Then
       Begin
           matriz_ordenar := nil;
           SetLength (matriz_ordenar, npt, (Number_subwatersheds + 1));
           For loop_npt3 := 1 to npt do
              Begin
                  For loop_nopt3 := 1 to Number_subwatersheds do
                     matriz_ordenar[(loop_npt3 - 1), (loop_nopt3 - 1)] := Xf_Kss [(loop_npt3 - 1), (loop_nopt3 - 1)];
                  matriz_ordenar[(loop_npt3 - 1), Number_subwatersheds] := Xf_Kss [(loop_npt3 - 1), Number_subwatersheds];
              End;
           QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
           Xf_Kss := nil;
           SetLength (Xf_Kss, npt, (Number_subwatersheds + 1));
           For loop_npt4 := 1 to npt do
              For loop_nopt4 := 0 to Number_subwatersheds do
                 Xf_Kss[(loop_npt4 - 1), loop_nopt4] := matriz_ordenar [(loop_npt4 - 1), loop_nopt4];
       End;
    // Ordenar matriz de Kss

    // Ordenar matriz de Kcr
    If Calibrate_Kcap_DT = True Then
       Begin
           matriz_ordenar := nil;
           SetLength (matriz_ordenar, npt, (Number_subwatersheds + 1));
              For loop_npt3 := 1 to npt do
                 Begin
                     For loop_nopt3 := 1 to Number_subwatersheds do
                        matriz_ordenar[(loop_npt3 - 1), (loop_nopt3 - 1)] := Xf_Kcr [(loop_npt3 - 1), (loop_nopt3 - 1)];
                     matriz_ordenar[(loop_npt3 - 1), Number_subwatersheds] := Xf_Kcr [(loop_npt3 - 1), Number_subwatersheds];
                 End;
           QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
           Xf_Kcr := nil;
           SetLength (Xf_Kcr, npt, (Number_subwatersheds + 1));
           For loop_npt4 := 1 to npt do
              For loop_nopt4 := 0 to Number_subwatersheds do
                 Xf_Kcr[(loop_npt4 - 1), loop_nopt4] := matriz_ordenar [(loop_npt4 - 1), loop_nopt4];
       End;
    // Ordenar matriz de Kcr


    Bestf := Xf_L [0, nopt_L];
    Worstf := Xf_L [(npt - 1), nopt_L];
    // Monta matriz com os valor de BestX e WorstX
    BestX_L := nil;
    WorstX_L := nil;
    SetLength (BestX_L, nopt_L);
    SetLength (WorstX_L, nopt_L);

    For loop_nopt5 := 1 to nopt_L do
       Begin
           BestX_L [(loop_nopt5 - 1)] := Xf_L [0, (loop_nopt5 - 1)];
           WorstX_L [(loop_nopt5 - 1)] := Xf_L [(npt - 1), (loop_nopt5 - 1)];
       End;
    // Monta matriz com os valor de BestX e WorstX - FIM

    // Monta matriz com os valor de BestX de Lambda, Kb, Kss e Kcr e WorstX de Lambda, Kb, Kss e Kcr
    If Calibrate_Lambda_DT = True Then
       Begin
           BestX_Lambda := nil;
           WorstX_Lambda := nil;
           SetLength (BestX_Lambda, Number_subwatersheds);
           SetLength (WorstX_Lambda, Number_subwatersheds);
       End;

    If Calibrate_Kb_DT = True Then
       Begin
           BestX_Kb := nil;
           WorstX_Kb := nil;
           SetLength (BestX_Kb, Number_subwatersheds);
           SetLength (WorstX_Kb, Number_subwatersheds);
       End;

    If Calibrate_Kss_DT = True Then
       Begin
           BestX_Kss := nil;
           WorstX_Kss := nil;
           SetLength (BestX_Kss, Number_subwatersheds);
           SetLength (WorstX_Kss, Number_subwatersheds);
       End;

    If Calibrate_Kcap_DT = True Then
       Begin
           BestX_Kcr := nil;
           WorstX_Kcr := nil;
           SetLength (BestX_Kcr, Number_subwatersheds);
           SetLength (WorstX_Kcr, Number_subwatersheds);
       End;

    For loop_nopt5 := 1 to Number_subwatersheds do
       Begin
           If Calibrate_Lambda_DT = True Then
              Begin
                  BestX_Lambda [(loop_nopt5 - 1)] := Xf_Lambda [0, (loop_nopt5 - 1)];
                  WorstX_Lambda [(loop_nopt5 - 1)] := Xf_Lambda [(npt - 1), (loop_nopt5 - 1)];
              End;
           If Calibrate_Kb_DT = True Then
              Begin
                  BestX_Kb [(loop_nopt5 - 1)] := Xf_Kb [0, (loop_nopt5 - 1)];
                  WorstX_Kb [(loop_nopt5 - 1)] := Xf_Kb [(npt - 1), (loop_nopt5 - 1)];
              End;
           If Calibrate_Kss_DT = True Then
              Begin
                  BestX_Kss [(loop_nopt5 - 1)] := Xf_Kss [0, (loop_nopt5 - 1)];
                  WorstX_Kss [(loop_nopt5 - 1)] := Xf_Kss [(npt - 1), (loop_nopt5 - 1)];
              End;
           If Calibrate_Kcap_DT = True Then
              Begin
                  BestX_Kcr [(loop_nopt5 - 1)] := Xf_Kcr [0, (loop_nopt5 - 1)];
                  WorstX_Kcr [(loop_nopt5 - 1)] := Xf_Kcr [(npt - 1), (loop_nopt5 - 1)];
              End;
       End;
    // Monta matriz com os valor de BestX de Lambda, Kb, Kss e Kcr e WorstX de Lambda, Kb, Kss e Kcr - FIM

    // Loop on complexes (sub-populations)
    cx_L := nil;
    cf_L := nil;
    SetLength (cx_L, npg, nopt_L);
    SetLength (cf_L, npg, (nopt_L + 1));

    If Calibrate_Lambda_DT = True Then
       Begin
           cx_Lambda := nil;
           cf_Lambda := nil;
           SetLength (cx_Lambda, npg, Number_subwatersheds);
           SetLength (cf_Lambda, npg, (Number_subwatersheds + 1));
       End;

    If Calibrate_Kb_DT = True Then
       Begin
           cx_Kb := nil;
           cf_Kb := nil;
           SetLength (cx_Kb, npg, Number_subwatersheds);
           SetLength (cf_Kb, npg, (Number_subwatersheds + 1));
       End;

    If Calibrate_Kss_DT = True Then
       Begin
           cx_Kss := nil;
           cf_Kss := nil;
           SetLength (cx_Kss, npg, Number_subwatersheds);
           SetLength (cf_Kss, npg, (Number_subwatersheds + 1));
       End;

    If Calibrate_Kcap_DT = True Then
       Begin
           cx_Kcr := nil;
           cf_Kcr := nil;
           SetLength (cx_Kcr, npg, Number_subwatersheds);
           SetLength (cf_Kcr, npg, (Number_subwatersheds + 1));
       End;

    Repeat
        For igs := 1 to ngs do
           Begin
               If Encerrar = 1 Then
                   Break;
               //If checkbox.Checked = True Then Break;
              // Partition the population into complexes (sub-populations)
               For k1 := 1 to npg do
                  Begin
                      k2 := ((k1 - 1) * ngs) + igs;
                      For loop_nopt6 := 1 to nopt_L do
                         Begin
                             cx_L [(k1 - 1), (loop_nopt6 - 1)] := Xf_L [(k2 - 1), (loop_nopt6 - 1)];
                             cf_L [(k1 - 1), (loop_nopt6 - 1)] := Xf_L [(k2 - 1), (loop_nopt6 - 1)];
                         End;
                      cf_L [(k1 - 1), nopt_L] := Xf_L [(k2 - 1), nopt_L];

                      For loop_nopt6 := 1 to Number_subwatersheds do
                         Begin
                             If Calibrate_Lambda_DT = True Then
                                Begin
                                    cx_Lambda [(k1 - 1), (loop_nopt6 - 1)] := Xf_Lambda [(k2 - 1), (loop_nopt6 - 1)];
                                    cf_Lambda [(k1 - 1), (loop_nopt6 - 1)] := Xf_Lambda [(k2 - 1), (loop_nopt6 - 1)];
                                End;
                             If Calibrate_Kb_DT = True Then
                                Begin
                                    cx_Kb [(k1 - 1), (loop_nopt6 - 1)] := Xf_Kb [(k2 - 1), (loop_nopt6 - 1)];
                                    cf_Kb [(k1 - 1), (loop_nopt6 - 1)] := Xf_Kb [(k2 - 1), (loop_nopt6 - 1)];
                                End;
                             If Calibrate_Kss_DT = True Then
                                Begin
                                    cx_Kss [(k1 - 1), (loop_nopt6 - 1)] := Xf_Kss [(k2 - 1), (loop_nopt6 - 1)];
                                    cf_Kss [(k1 - 1), (loop_nopt6 - 1)] := Xf_Kss [(k2 - 1), (loop_nopt6 - 1)];
                                End;
                             If Calibrate_Kcap_DT = True Then
                                Begin
                                    cx_Kcr [(k1 - 1), (loop_nopt6 - 1)] := Xf_Kcr [(k2 - 1), (loop_nopt6 - 1)];
                                    cf_Kcr [(k1 - 1), (loop_nopt6 - 1)] := Xf_Kcr [(k2 - 1), (loop_nopt6 - 1)];
                                End;
                         End;
                      If Calibrate_Lambda_DT = True Then cf_Lambda [(k1 - 1), Number_subwatersheds] := Xf_Lambda [(k2 - 1), Number_subwatersheds];
                      If Calibrate_Kb_DT = True Then cf_Kb [(k1 - 1), Number_subwatersheds] := Xf_Kb [(k2 - 1), Number_subwatersheds];
                      If Calibrate_Kss_DT = True Then cf_Kss [(k1 - 1), Number_subwatersheds] := Xf_Kss [(k2 - 1), Number_subwatersheds];
                      If Calibrate_Kcap_DT = True Then cf_Kcr [(k1 - 1), Number_subwatersheds] := Xf_Kcr [(k2 - 1), Number_subwatersheds];
                  End;
               // Partition the population into complexes (sub-populations)

               //Evolve sub-population igs for nspl steps
               For loop := 1 to nspl do
                  Begin
                      //If checkbox.Checked = True Then Break;
                      // Select simplex by sampling the complex according to a linear probability distribution
                      Matriz_lcs := nil;
                      //lcs := nil;
                      SetLength (matriz_lcs, nps);
                      Matriz_lcs [0] := 1;

                      For k3 := 2 to nps do
                         Begin
                             For iter := 1 to 1000 do
                                Begin
                                    lpos := 1 + Floor(npg + 0.5 - sqrt(sqr(npg + 0.5) - (npg * (npg + 1) * Random)));

                                    If Confere_Array_lpos(matriz_lcs, (k3 - 1), lpos) = False Then
                                       Break;
                                End;
                             matriz_lcs [k3 - 1] := lpos;
                         End;

                      lcs := nil;
                      SetLength (lcs, nps);
                      QuickSort_lcs(Low (matriz_lcs), High (matriz_lcs));

                      For loop_nps1 := 1 to nps do
                         lcs [loop_nps1 - 1] := matriz_lcs [loop_nps1 - 1];

                      //ShowMessage(IntToStr (lcs [0]) + ';' + IntToStr (lcs [1]) + ';' + IntToStr (lcs [2]) + ';' + IntToStr (lcs [3]));
                      // Select simplex by sampling the complex according to a linear probability distribution

                      // Construct the simplex
                      s_L := nil;
                      sf_L := nil;
                      SetLength (s_L, nps, nopt_L);
                      SetLength (sf_L, nps);

                      If Calibrate_Lambda_DT = True Then
                         Begin
                             s_Lambda := nil;
                             sf_Lambda := nil;
                             SetLength (s_Lambda, nps, Number_subwatersheds);
                             SetLength (sf_Lambda, nps);
                         End;

                      If Calibrate_Kb_DT = True Then
                         Begin
                             s_Kb := nil;
                             sf_Kb := nil;
                             SetLength (s_Kb, nps, Number_subwatersheds);
                             SetLength (sf_Kb, nps);
                         End;

                      If Calibrate_Kss_DT = True Then
                         Begin
                             s_Kss := nil;
                             sf_Kss := nil;
                             SetLength (s_Kss, nps, Number_subwatersheds);
                             SetLength (sf_Kss, nps);
                         End;

                      If Calibrate_Kcap_DT = True Then
                         Begin
                             s_Kcr := nil;
                             sf_Kcr := nil;
                             SetLength (s_Kcr, nps, Number_subwatersheds);
                             SetLength (sf_Kcr, nps);
                         End;

                      For loop_nps2 := 1 to nps do
                         Begin
                             For loop_nopt7 := 1 to nopt_L do
                                s_L [(loop_nps2 - 1), (loop_nopt7 - 1)] := cx_L [(lcs [loop_nps2 - 1] - 1) , (loop_nopt7 - 1)];
                             sf_L [loop_nps2 - 1] := cf_L [(lcs [loop_nps2 - 1] - 1), nopt_L];

                             For loop_nopt7 := 1 to Number_subwatersheds do
                                Begin
                                    If Calibrate_Lambda_DT = True Then s_Lambda [(loop_nps2 - 1), (loop_nopt7 - 1)] := cx_Lambda [(lcs [loop_nps2 - 1] - 1) , (loop_nopt7 - 1)];
                                    If Calibrate_Kb_DT = True Then s_Kb [(loop_nps2 - 1), (loop_nopt7 - 1)] := cx_Kb [(lcs [loop_nps2 - 1] - 1) , (loop_nopt7 - 1)];
                                    If Calibrate_Kss_DT = True Then s_Kss [(loop_nps2 - 1), (loop_nopt7 - 1)] := cx_Kss [(lcs [loop_nps2 - 1] - 1) , (loop_nopt7 - 1)];
                                    If Calibrate_Kcap_DT = True Then s_Kcr [(loop_nps2 - 1), (loop_nopt7 - 1)] := cx_Kcr [(lcs [loop_nps2 - 1] - 1) , (loop_nopt7 - 1)];
                                End;
                             If Calibrate_Lambda_DT = True Then sf_Lambda [loop_nps2 - 1] := cf_Lambda [(lcs [loop_nps2 - 1] - 1), Number_subwatersheds];
                             If Calibrate_Kb_DT = True Then sf_Kb [loop_nps2 - 1] := cf_Kb [(lcs [loop_nps2 - 1] - 1), Number_subwatersheds];
                             If Calibrate_Kss_DT = True Then sf_Kss [loop_nps2 - 1] := cf_Kss [(lcs [loop_nps2 - 1] - 1), Number_subwatersheds];
                             If Calibrate_Kcap_DT = True Then sf_Kcr [loop_nps2 - 1] := cf_Kcr [(lcs [loop_nps2 - 1] - 1), Number_subwatersheds];
                         End;

                      /// Alfa
                      For Cont_Alpha_SCE := 1 to Alpha_SCE do
                         Begin
                             // CALL FUNCTION CCEUA HERE
                             If Encerrar = 1 Then
                                Break;

//#### CCEUA #####################################################################################################
                             CCEUA(cdsEntrada, cdsParameter, cdsParameters_Distribuido, cdsResults, cdsResults_Lambda, cdsResults_Kb, cdsResults_Kss, cdsResults_Kcr, strP5, Hydrograph, graphAmin, graphAmax, graphAmed, graphKs, graphP, 1, 0.5, bl_L, bu_L, bl_DT, bu_DT);
//#### CCEUA #####################################################################################################





                             //Replace the worst point in Simplex with the new point
                             For loop_nopt8 := 1 to nopt_L do
                                s_L [(nps - 1), (loop_nopt8 - 1)] := snew_L [loop_nopt8 - 1];

                             sf_L [nps - 1] := fnew_L;

                             For loop_nopt8 := 1 to Number_subwatersheds do
                                Begin
                                    If Calibrate_Lambda_DT = True Then s_Lambda [(nps - 1), (loop_nopt8 - 1)] := snew_Lambda [loop_nopt8 - 1];
                                    If Calibrate_Kb_DT = True Then s_Kb [(nps - 1), (loop_nopt8 - 1)] := snew_Kb [loop_nopt8 - 1];
                                    If Calibrate_Kss_DT = True Then s_Kss [(nps - 1), (loop_nopt8 - 1)] := snew_Kss [loop_nopt8 - 1];
                                    If Calibrate_Kcap_DT = True Then s_Kcr [(nps - 1), (loop_nopt8 - 1)] := snew_Kcr [loop_nopt8 - 1];
                                End;

                             If Calibrate_Lambda_DT = True Then sf_Lambda [nps - 1] := fnew_Lambda;
                             If Calibrate_Kb_DT = True Then sf_Kb [nps - 1] := fnew_Kb;
                             If Calibrate_Kss_DT = True Then sf_Kss [nps - 1] := fnew_Kss;
                             If Calibrate_Kcap_DT = True Then sf_Kcr [nps - 1] := fnew_Kcr;
                             //Replace the worst point in Simplex with the new point
                         End;
                      /// Alfa FIM

                      // Replace the simplex into the complex
                      For loop_nopt9 := 1 to nopt_L do
                         Begin
                             cx_L [(npg - 1) , (loop_nopt9 - 1)] := s_L [(nps - 1), (loop_nopt9 - 1)];
                             cf_L [(npg - 1) , (loop_nopt9 - 1)] := s_L [(nps - 1), (loop_nopt9 - 1)];
                         End;
                      cf_L [(npg - 1) , nopt_L] := sf_L [(nps - 1)];

                      For loop_nopt9 := 1 to Number_subwatersheds do
                         Begin
                             If Calibrate_Lambda_DT = True Then
                                Begin
                                    cx_Lambda [(npg - 1) , (loop_nopt9 - 1)] := s_Lambda [(nps - 1), (loop_nopt9 - 1)];
                                    cf_Lambda [(npg - 1) , (loop_nopt9 - 1)] := s_Lambda [(nps - 1), (loop_nopt9 - 1)];
                                End;
                             If Calibrate_Kb_DT = True Then
                                Begin
                                    cx_Kb [(npg - 1) , (loop_nopt9 - 1)] := s_Kb [(nps - 1), (loop_nopt9 - 1)];
                                    cf_Kb [(npg - 1) , (loop_nopt9 - 1)] := s_Kb [(nps - 1), (loop_nopt9 - 1)];
                                End;
                             If Calibrate_Kss_DT = True Then
                                Begin
                                    cx_Kss [(npg - 1) , (loop_nopt9 - 1)] := s_Kss [(nps - 1), (loop_nopt9 - 1)];
                                    cf_Kss [(npg - 1) , (loop_nopt9 - 1)] := s_Kss [(nps - 1), (loop_nopt9 - 1)];
                                End;
                             If Calibrate_Kcap_DT = True Then
                                Begin
                                    cx_Kcr [(npg - 1) , (loop_nopt9 - 1)] := s_Kcr [(nps - 1), (loop_nopt9 - 1)];
                                    cf_Kcr [(npg - 1) , (loop_nopt9 - 1)] := s_Kcr [(nps - 1), (loop_nopt9 - 1)];
                                End;
                         End;
                      If Calibrate_Lambda_DT = True Then cf_Lambda [(npg - 1) , Number_subwatersheds] := sf_Lambda [(nps - 1)];
                      If Calibrate_Kb_DT = True Then cf_Kb [(npg - 1) , Number_subwatersheds] := sf_Kb [(nps - 1)];
                      If Calibrate_Kss_DT = True Then cf_Kss [(npg - 1) , Number_subwatersheds] := sf_Kss [(nps - 1)];
                      If Calibrate_Kcap_DT = True Then cf_Kcr [(npg - 1) , Number_subwatersheds] := sf_Kcr [(nps - 1)];
                      // Replace the simplex into the complex

                      // Sort de complex
                      matriz_ordenar := nil;
                      SetLength (matriz_ordenar, npg, (nopt_L + 1));
                      For loop_npg1 := 1 to npg do
                         Begin
                             For loop_nopt10 := 1 to nopt_L do
                                matriz_ordenar [(loop_npg1 - 1), (loop_nopt10 - 1)] := cf_L [(loop_npg1 - 1), (loop_nopt10 - 1)];
                             matriz_ordenar [(loop_npg1 - 1), nopt_L] := cf_L [(loop_npg1 - 1), nopt_L];
                         End;

                      QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (nopt_L + 1), nopt_L);
                      cx_L := nil;
                      cf_L := nil;
                      SetLength (cx_L, npg, nopt_L);
                      SetLength (cf_L, npg, (nopt_L + 1));

                      For loop_npg2 := 1 to npg do
                         Begin
                             For loop_nopt11 := 1 to nopt_L do
                                Begin
                                    cx_L [(loop_npg2 - 1), (loop_nopt11 - 1)] := matriz_ordenar [(loop_npg2 - 1), (loop_nopt11 - 1)];
                                    cf_L [(loop_npg2 - 1), (loop_nopt11 - 1)] := matriz_ordenar [(loop_npg2 - 1), (loop_nopt11 - 1)];
                                End;
                             cf_L [(loop_npg2 - 1), nopt_L] := matriz_ordenar [(loop_npg2 - 1), nopt_L];
                         End;

                      //lambda - ordenar complexo
                      If Calibrate_Lambda_DT = True Then
                         Begin
                             matriz_ordenar := nil;
                             SetLength (matriz_ordenar, npg, (Number_subwatersheds + 1));
                             For loop_npg1 := 1 to npg do
                                Begin
                                    For loop_nopt10 := 1 to Number_subwatersheds do
                                       matriz_ordenar [(loop_npg1 - 1), (loop_nopt10 - 1)] := cf_Lambda [(loop_npg1 - 1), (loop_nopt10 - 1)];
                                    matriz_ordenar [(loop_npg1 - 1), Number_subwatersheds] := cf_Lambda [(loop_npg1 - 1), Number_subwatersheds];
                                End;
                             QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
                             cx_Lambda := nil;
                             cf_Lambda := nil;
                             SetLength (cx_Lambda, npg, Number_subwatersheds);
                             SetLength (cf_Lambda, npg, (Number_subwatersheds + 1));
                             For loop_npg2 := 1 to npg do
                                Begin
                                    For loop_nopt11 := 1 to Number_subwatersheds do
                                       Begin
                                           cx_Lambda [(loop_npg2 - 1), (loop_nopt11 - 1)] := matriz_ordenar [(loop_npg2 - 1), (loop_nopt11 - 1)];
                                           cf_Lambda [(loop_npg2 - 1), (loop_nopt11 - 1)] := matriz_ordenar [(loop_npg2 - 1), (loop_nopt11 - 1)];
                                       End;
                                    cf_Lambda [(loop_npg2 - 1), Number_subwatersheds] := matriz_ordenar [(loop_npg2 - 1), Number_subwatersheds];
                                End;
                         End;
                      //lambda - ordenar complexo

                      //Kb - ordenar complexo
                      If Calibrate_Kb_DT = True Then
                         Begin
                             matriz_ordenar := nil;
                             SetLength (matriz_ordenar, npg, (Number_subwatersheds + 1));
                             For loop_npg1 := 1 to npg do
                                Begin
                                    For loop_nopt10 := 1 to Number_subwatersheds do
                                       matriz_ordenar [(loop_npg1 - 1), (loop_nopt10 - 1)] := cf_Kb [(loop_npg1 - 1), (loop_nopt10 - 1)];
                                    matriz_ordenar [(loop_npg1 - 1), Number_subwatersheds] := cf_Kb [(loop_npg1 - 1), Number_subwatersheds];
                                End;
                             QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
                             cx_Kb := nil;
                             cf_Kb := nil;
                             SetLength (cx_Kb, npg, Number_subwatersheds);
                             SetLength (cf_Kb, npg, (Number_subwatersheds + 1));
                             For loop_npg2 := 1 to npg do
                                Begin
                                    For loop_nopt11 := 1 to Number_subwatersheds do
                                       Begin
                                           cx_Kb [(loop_npg2 - 1), (loop_nopt11 - 1)] := matriz_ordenar [(loop_npg2 - 1), (loop_nopt11 - 1)];
                                           cf_Kb [(loop_npg2 - 1), (loop_nopt11 - 1)] := matriz_ordenar [(loop_npg2 - 1), (loop_nopt11 - 1)];
                                       End;
                                    cf_Kb [(loop_npg2 - 1), Number_subwatersheds] := matriz_ordenar [(loop_npg2 - 1), Number_subwatersheds];
                                End;
                         End;
                      //Kb - ordenar complexo

                      //Kss - ordenar complexo
                      If Calibrate_Kss_DT = True Then
                         Begin
                             matriz_ordenar := nil;
                             SetLength (matriz_ordenar, npg, (Number_subwatersheds + 1));
                                For loop_npg1 := 1 to npg do
                                   Begin
                                       For loop_nopt10 := 1 to Number_subwatersheds do
                                          matriz_ordenar [(loop_npg1 - 1), (loop_nopt10 - 1)] := cf_Kss [(loop_npg1 - 1), (loop_nopt10 - 1)];
                                       matriz_ordenar [(loop_npg1 - 1), Number_subwatersheds] := cf_Kss [(loop_npg1 - 1), Number_subwatersheds];
                                   End;
                                QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
                                cx_Kss := nil;
                                cf_Kss := nil;
                                SetLength (cx_Kss, npg, Number_subwatersheds);
                                SetLength (cf_Kss, npg, (Number_subwatersheds + 1));
                                For loop_npg2 := 1 to npg do
                                   Begin
                                       For loop_nopt11 := 1 to Number_subwatersheds do
                                          Begin
                                              cx_Kss [(loop_npg2 - 1), (loop_nopt11 - 1)] := matriz_ordenar [(loop_npg2 - 1), (loop_nopt11 - 1)];
                                              cf_Kss [(loop_npg2 - 1), (loop_nopt11 - 1)] := matriz_ordenar [(loop_npg2 - 1), (loop_nopt11 - 1)];
                                          End;
                                       cf_Kss [(loop_npg2 - 1), Number_subwatersheds] := matriz_ordenar [(loop_npg2 - 1), Number_subwatersheds];
                                   End;
                         End;
                      //Kss - ordenar complexo

                      //Kcr - ordenar complexo
                      If Calibrate_Kcap_DT = True Then
                         Begin
                             matriz_ordenar := nil;
                             SetLength (matriz_ordenar, npg, (Number_subwatersheds + 1));
                                For loop_npg1 := 1 to npg do
                                   Begin
                                       For loop_nopt10 := 1 to Number_subwatersheds do
                                          matriz_ordenar [(loop_npg1 - 1), (loop_nopt10 - 1)] := cf_Kcr [(loop_npg1 - 1), (loop_nopt10 - 1)];
                                       matriz_ordenar [(loop_npg1 - 1), Number_subwatersheds] := cf_Kcr [(loop_npg1 - 1), Number_subwatersheds];
                                   End;
                             QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
                             cx_Kcr := nil;
                             cf_Kcr := nil;
                             SetLength (cx_Kcr, npg, Number_subwatersheds);
                             SetLength (cf_Kcr, npg, (Number_subwatersheds + 1));
                             For loop_npg2 := 1 to npg do
                                Begin
                                    For loop_nopt11 := 1 to Number_subwatersheds do
                                       Begin
                                           cx_Kcr [(loop_npg2 - 1), (loop_nopt11 - 1)] := matriz_ordenar [(loop_npg2 - 1), (loop_nopt11 - 1)];
                                           cf_Kcr [(loop_npg2 - 1), (loop_nopt11 - 1)] := matriz_ordenar [(loop_npg2 - 1), (loop_nopt11 - 1)];
                                       End;
                                    cf_Kcr [(loop_npg2 - 1), Number_subwatersheds] := matriz_ordenar [(loop_npg2 - 1), Number_subwatersheds];
                                End;
                         End;
                      //Kcr - ordenar complexo
                      // Sort de complex
                  End;
           //Evolve sub-population igs for nspl steps

          //Replace the complex back into the population
               For k1 := 1 to npg do
                  Begin
                      k2 := ((k1 - 1) * ngs) + igs;
                      For loop_nopt12 := 1 to nopt_L do
                         Begin
                             X_L [(k2 - 1), (loop_nopt12 - 1)] := cx_L [(k1 - 1), (loop_nopt12 - 1)];
                             Xf_L [(k2 - 1), (loop_nopt12 - 1)] := cx_L [(k1 - 1), (loop_nopt12 - 1)];
                         End;
                      Xf_L [(k2 - 1), nopt_L] := cf_L [(k1 - 1), nopt_L];

                      For loop_nopt12 := 1 to Number_subwatersheds do
                         Begin
                             If Calibrate_Lambda_DT = True Then
                                Begin
                                    X_Lambda [(k2 - 1), (loop_nopt12 - 1)] := cx_Lambda [(k1 - 1), (loop_nopt12 - 1)];
                                    Xf_Lambda [(k2 - 1), (loop_nopt12 - 1)] := cx_Lambda [(k1 - 1), (loop_nopt12 - 1)];
                                End;
                             If Calibrate_Kb_DT = True Then
                                Begin
                                    X_Kb [(k2 - 1), (loop_nopt12 - 1)] := cx_Kb [(k1 - 1), (loop_nopt12 - 1)];
                                    Xf_Kb [(k2 - 1), (loop_nopt12 - 1)] := cx_Kb [(k1 - 1), (loop_nopt12 - 1)];
                                End;
                             If Calibrate_Kss_DT = True Then
                                Begin
                                    X_Kss [(k2 - 1), (loop_nopt12 - 1)] := cx_Kss [(k1 - 1), (loop_nopt12 - 1)];
                                    Xf_Kss [(k2 - 1), (loop_nopt12 - 1)] := cx_Kss [(k1 - 1), (loop_nopt12 - 1)];
                                End;
                             If Calibrate_Kcap_DT = True Then
                                Begin
                                    X_Kcr [(k2 - 1), (loop_nopt12 - 1)] := cx_Kcr [(k1 - 1), (loop_nopt12 - 1)];
                                    Xf_Kcr [(k2 - 1), (loop_nopt12 - 1)] := cx_Kcr [(k1 - 1), (loop_nopt12 - 1)];
                                End;
                         End;
                      If Calibrate_Lambda_DT = True Then Xf_Lambda [(k2 - 1), Number_subwatersheds] := cf_Lambda [(k1 - 1), Number_subwatersheds];
                      If Calibrate_Kb_DT = True Then Xf_Kb [(k2 - 1), Number_subwatersheds] := cf_Kb [(k1 - 1), Number_subwatersheds];
                      If Calibrate_Kss_DT = True Then Xf_Kss [(k2 - 1), Number_subwatersheds] := cf_Kss [(k1 - 1), Number_subwatersheds];
                      If Calibrate_Kcap_DT = True Then Xf_Kcr [(k2 - 1), Number_subwatersheds] := cf_Kcr [(k1 - 1), Number_subwatersheds];
                  End;
          //Replace the complex back into the population

           End;//For igs := 1 to ngs do
//------Repeat - Continuação
           // Shuffle the complexes
        matriz_ordenar := nil;
        SetLength (matriz_ordenar, npt, (nopt_L + 1));

        For loop_npt5 := 1 to npt do
           Begin
               For loop_nopt13 := 1 to nopt_L do
                  matriz_ordenar [(loop_npt5 - 1), (loop_nopt13 - 1)] := X_L [(loop_npt5 - 1), (loop_nopt13 - 1)];
               matriz_ordenar [(loop_npt5 - 1), nopt_L] := Xf_L [(loop_npt5 - 1), nopt_L];
           End;

        QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (nopt_L + 1), nopt_L);
        X_L := nil;
        Xf_L := nil;
        SetLength (X_L, npt, nopt_L);
        SetLength (Xf_L, npt, (nopt_L + 1));

        For loop_npt6 := 1 to npt do
           Begin
               For loop_nopt14 := 1 to nopt_L do
                  Begin
                      X_L [(loop_npt6 - 1), (loop_nopt14 - 1)] := matriz_ordenar [(loop_npt6 - 1), (loop_nopt14 - 1)];
                      Xf_L [(loop_npt6 - 1), (loop_nopt14 - 1)] := matriz_ordenar [(loop_npt6 - 1), (loop_nopt14 - 1)];
                  End;
               Xf_L [(loop_npt6 - 1), nopt_L] := matriz_ordenar [(loop_npt6 - 1), nopt_L];
           End;

        //Lambda - shuffle the complexes
        If Calibrate_Lambda_DT = True Then
           Begin
               matriz_ordenar := nil;
               SetLength (matriz_ordenar, npt, (Number_subwatersheds + 1));
               For loop_npt5 := 1 to npt do
                  Begin
                      For loop_nopt13 := 1 to Number_subwatersheds do
                         matriz_ordenar [(loop_npt5 - 1), (loop_nopt13 - 1)] := X_Lambda [(loop_npt5 - 1), (loop_nopt13 - 1)];
                      matriz_ordenar [(loop_npt5 - 1), Number_subwatersheds] := Xf_Lambda [(loop_npt5 - 1), Number_subwatersheds];
                  End;
               QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
               X_Lambda := nil;
               Xf_Lambda := nil;
               SetLength (X_Lambda, npt, Number_subwatersheds);
               SetLength (Xf_Lambda, npt, (Number_subwatersheds + 1));
               For loop_npt6 := 1 to npt do
                  Begin
                      For loop_nopt14 := 1 to Number_subwatersheds do
                         Begin
                             X_Lambda [(loop_npt6 - 1), (loop_nopt14 - 1)] := matriz_ordenar [(loop_npt6 - 1), (loop_nopt14 - 1)];
                             Xf_Lambda [(loop_npt6 - 1), (loop_nopt14 - 1)] := matriz_ordenar [(loop_npt6 - 1), (loop_nopt14 - 1)];
                         End;
                      Xf_Lambda [(loop_npt6 - 1), Number_subwatersheds] := matriz_ordenar [(loop_npt6 - 1), Number_subwatersheds];
                  End;
           End;
        //Lambda - shuffle the complexes

        //Kb - shuffle the complexes
        If Calibrate_Kb_DT = True Then
           Begin
               matriz_ordenar := nil;
               SetLength (matriz_ordenar, npt, (Number_subwatersheds + 1));
               For loop_npt5 := 1 to npt do
                  Begin
                      For loop_nopt13 := 1 to Number_subwatersheds do
                         matriz_ordenar [(loop_npt5 - 1), (loop_nopt13 - 1)] := X_Kb [(loop_npt5 - 1), (loop_nopt13 - 1)];
                      matriz_ordenar [(loop_npt5 - 1), Number_subwatersheds] := Xf_Kb [(loop_npt5 - 1), Number_subwatersheds];
                  End;
               QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
               X_Kb := nil;
               Xf_Kb := nil;
               SetLength (X_Kb, npt, Number_subwatersheds);
               SetLength (Xf_Kb, npt, (Number_subwatersheds + 1));
               For loop_npt6 := 1 to npt do
                  Begin
                      For loop_nopt14 := 1 to Number_subwatersheds do
                         Begin
                             X_Kb [(loop_npt6 - 1), (loop_nopt14 - 1)] := matriz_ordenar [(loop_npt6 - 1), (loop_nopt14 - 1)];
                             Xf_Kb [(loop_npt6 - 1), (loop_nopt14 - 1)] := matriz_ordenar [(loop_npt6 - 1), (loop_nopt14 - 1)];
                         End;
                      Xf_Kb [(loop_npt6 - 1), Number_subwatersheds] := matriz_ordenar [(loop_npt6 - 1), Number_subwatersheds];
                  End;
           End;
        //Kb - shuffle the complexes

        //Kss - shuffle the complexes
        If Calibrate_Kss_DT = True Then
           Begin
               matriz_ordenar := nil;
               SetLength (matriz_ordenar, npt, (Number_subwatersheds + 1));
               For loop_npt5 := 1 to npt do
                  Begin
                      For loop_nopt13 := 1 to Number_subwatersheds do
                         matriz_ordenar [(loop_npt5 - 1), (loop_nopt13 - 1)] := X_Kss [(loop_npt5 - 1), (loop_nopt13 - 1)];
                      matriz_ordenar [(loop_npt5 - 1), Number_subwatersheds] := Xf_Kss [(loop_npt5 - 1), Number_subwatersheds];
                  End;
               QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
               X_Kss := nil;
               Xf_Kss := nil;
               SetLength (X_Kss, npt, Number_subwatersheds);
               SetLength (Xf_Kss, npt, (Number_subwatersheds + 1));
               For loop_npt6 := 1 to npt do
                  Begin
                      For loop_nopt14 := 1 to Number_subwatersheds do
                         Begin
                             X_Kss [(loop_npt6 - 1), (loop_nopt14 - 1)] := matriz_ordenar [(loop_npt6 - 1), (loop_nopt14 - 1)];
                             Xf_Kss [(loop_npt6 - 1), (loop_nopt14 - 1)] := matriz_ordenar [(loop_npt6 - 1), (loop_nopt14 - 1)];
                         End;
                      Xf_Kss [(loop_npt6 - 1), Number_subwatersheds] := matriz_ordenar [(loop_npt6 - 1), Number_subwatersheds];
                  End;
           End;
        //Kss - shuffle the complexes

        //Kcr - shuffle the complexes
        If Calibrate_Kcap_DT = True Then
           Begin
               matriz_ordenar := nil;
               SetLength (matriz_ordenar, npt, (Number_subwatersheds + 1));
               For loop_npt5 := 1 to npt do
                  Begin
                      For loop_nopt13 := 1 to Number_subwatersheds do
                         matriz_ordenar [(loop_npt5 - 1), (loop_nopt13 - 1)] := X_Kcr [(loop_npt5 - 1), (loop_nopt13 - 1)];
                      matriz_ordenar [(loop_npt5 - 1), Number_subwatersheds] := Xf_Kcr [(loop_npt5 - 1), Number_subwatersheds];
                  End;
               QuickSort(Low (matriz_ordenar), High (matriz_ordenar), (Number_subwatersheds + 1), Number_subwatersheds);
               X_Kcr := nil;
               Xf_Kcr := nil;
               SetLength (X_Kcr, npt, Number_subwatersheds);
               SetLength (Xf_Kcr, npt, (Number_subwatersheds + 1));
               For loop_npt6 := 1 to npt do
                  Begin
                      For loop_nopt14 := 1 to Number_subwatersheds do
                         Begin
                             X_Kcr [(loop_npt6 - 1), (loop_nopt14 - 1)] := matriz_ordenar [(loop_npt6 - 1), (loop_nopt14 - 1)];
                             Xf_Kcr [(loop_npt6 - 1), (loop_nopt14 - 1)] := matriz_ordenar [(loop_npt6 - 1), (loop_nopt14 - 1)];
                         End;
                      Xf_Kcr [(loop_npt6 - 1), Number_subwatersheds] := matriz_ordenar [(loop_npt6 - 1), Number_subwatersheds];
                  End;
           End;
        //Kcr - shuffle the complexes   

        // Shuffle the complexes

        {If MessageDlg('Do you want to continue iterations?', mtConfirmation,
          [mbYes, mbNo], 0) = mrNo then Break;}
        If Encerrar = 1 Then
           Break;

    Until Xf_L [0, nopt_L] <= Constraint;

    //If cdsParameters.Locate('Parameter', 'SVSMC', [loCaseInsensitive]) = True Then SVSMC := X [0, (cdsParameters.RecNo - 1)];
    //If cdsParameters.Locate('Parameter', 'PWPSMC', [loCaseInsensitive]) = True Then PWPSMC := X [0, (cdsParameters.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'IVSMC', [loCaseInsensitive]) = True Then
       IVSMC := X_L [0, (cdsParameter.RecNo - 1)];

    //If cdsParameters.Locate('Parameter', 'SD', [loCaseInsensitive]) = True Then SD := X [0, (cdsParameters.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'Kb', [loCaseInsensitive]) = True Then
       Kb := X_L [0, (cdsParameter.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'Kss', [loCaseInsensitive]) = True Then
       Kss := X_L [0, (cdsParameter.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'Kcap', [loCaseInsensitive]) = True Then
       Kcap := X_L [0, (cdsParameter.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'Lambda', [loCaseInsensitive]) = True Then
       Lambda := X_L [0, (cdsParameter.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'Cs', [loCaseInsensitive]) = True Then
       Cs := X_L [0, (cdsParameter.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'Css', [loCaseInsensitive]) = True Then
       Css := X_L [0, (cdsParameter.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'Cbase', [loCaseInsensitive]) = True Then
       Cbase := X_L [0, (cdsParameter.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'Ac', [loCaseInsensitive]) = True Then
       Ac := X_L [0, (cdsParameter.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'Acc', [loCaseInsensitive]) = True Then
       Acc := X_L [0, (cdsParameter.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'Acr', [loCaseInsensitive]) = True Then
       Acr := X_L [0, (cdsParameter.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'AL', [loCaseInsensitive]) = True Then
       AL := X_L [0, (cdsParameter.RecNo - 1)];
    If cdsParameter.Locate('Parameter', 'PS', [loCaseInsensitive]) = True Then
       Pr := X_L [0, (cdsParameter.RecNo - 1)];

    {L := 0;
    BH(cdsEntrada, Hydrograph, 365, 1440, Lambda, Kb, Kss, Cs, Css);}
End;
//############################################## SCE - FIM #######################################################################
//################################################################################################################################