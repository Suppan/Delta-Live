//=============================================
// sfPlayerSC
//=============================================

// choose "Evaluate File" form the menu,
// or press cmd-a (select all)  + cmd-return

// single-play?=nil
// t   -> "performance-mode": every sf can be played only once
// nil -> "rehearse-mode": every sf can be restarted

(
var b1,button_sf1,synth_sf1;
var b2,button_sf2,synth_sf2;
var b3,button_sf3,synth_sf3;
var b4,button_sf4,synth_sf4;
var b5,button_sf5,synth_sf5;
var b6,button_sf6,synth_sf6;
var b7,button_sf7,synth_sf7;
var b8,button_sf8,synth_sf8;
var b9,button_sf9,synth_sf9;
var b10,button_sf10,synth_sf10;
var b11,button_sf11,synth_sf11;
var b12,button_sf12,synth_sf12;
var b13,button_sf13,synth_sf13;
var b14,button_sf14,synth_sf14;
var b15,button_sf15,synth_sf15;
var button_dump;
var dBsf1,dBsf2,dBsf3,dBsf4,dBsf5,dBsf6,dBsf7,dBsf8,dBsf9,dBsf10,dBsf11,dBsf12,dBsf13,dBsf14,dBsf15;
var dBtext1,dBtext2,dBtext3,dBtext4,dBtext5,dBtext6,dBtext7,dBtext8,dBtext9,dBtext10,dBtext11,dBtext12,dBtext13,dBtext14,dBtext15;
var sfPath0,sfPath1,sfPath2,sfPath3,sfPath4,sfPath5,sfPath6,sfPath7,sfPath8,sfPath9,sfPath10,sfPath11,sfPath12,sfPath13,sfPath14,sfPath15;

    s = Server.local;
    //s.options.device = "Fireface 400 (F0C)";    //ServerOptions.devices;
    s.options.memSize = 2**18;   //-> 262144 kilobytes (default: 2**13 -> 8192)
    s.boot;
    s.latency = 0;

s.waitForBoot({
    //dB-levels:
    //A:
    dBsf1   =     0.0;
    dBsf2   =     0.0;
    dBsf3   =     0.0;
    dBsf4   =     0.0;
    dBsf5   =    -4.0;
    dBsf6   =     0.0;
    dBsf7   =     0.0;
    dBsf8   =     0.0;
    dBsf9   =     0.0;
    //B:
    dBsf10   =     0.0;
    dBsf11   =     0.0;
    //C:
    dBsf12   =    -3.0;
    dBsf13   =     0.0;
    dBsf14   =     0.0;
    dBsf15   =     0.0;

    //Soundfile paths:
    sfPath0  = "/Users/wsuppan/Dropbox/2021/Apps/Delta-Live-0.12/sounds/";
    sfPath1  = sfPath0 ++ "A/0-sticks.wav";
    sfPath2  = sfPath0 ++ "A/1-water-splash.wav";
    sfPath3  = sfPath0 ++ "A/2-machine-noise1.wav";
    sfPath4  = sfPath0 ++ "A/3-machine-noise2.wav";
    sfPath5  = sfPath0 ++ "A/4-ugly-horn.wav";
    sfPath6  = sfPath0 ++ "A/5-crowd.wav";
    sfPath7  = sfPath0 ++ "A/6-kung-fu.wav";
    sfPath8  = sfPath0 ++ "A/7-car-stop.wav";
    sfPath9  = sfPath0 ++ "A/8-children.wav";
    sfPath10  = sfPath0 ++ "B/7-car-stop.wav";
    sfPath11  = sfPath0 ++ "B/8-children.wav";
    sfPath12  = sfPath0 ++ "C/9-car-horn-old.wav";
    sfPath13  = sfPath0 ++ "C/10-sticks.wav";
    sfPath14  = sfPath0 ++ "C/11-camera-noise.wav";
    sfPath15  = sfPath0 ++ "C/12-alabama.aif";

    //Buffer
    b1  = Buffer.cueSoundFile(s,sfPath1  ,0 ,2);
    b2  = Buffer.cueSoundFile(s,sfPath2  ,0 ,2);
    b3  = Buffer.cueSoundFile(s,sfPath3  ,0 ,2);
    b4  = Buffer.cueSoundFile(s,sfPath4  ,0 ,2);
    b5  = Buffer.cueSoundFile(s,sfPath5  ,0 ,2);
    b6  = Buffer.cueSoundFile(s,sfPath6  ,0 ,2);
    b7  = Buffer.cueSoundFile(s,sfPath7  ,0 ,2);
    b8  = Buffer.cueSoundFile(s,sfPath8  ,0 ,2);
    b9  = Buffer.cueSoundFile(s,sfPath9  ,0 ,2);
    b10  = Buffer.cueSoundFile(s,sfPath10  ,0 ,2);
    b11  = Buffer.cueSoundFile(s,sfPath11  ,0 ,2);
    b12  = Buffer.cueSoundFile(s,sfPath12  ,0 ,2);
    b13  = Buffer.cueSoundFile(s,sfPath13  ,0 ,2);
    b14  = Buffer.cueSoundFile(s,sfPath14  ,0 ,1);
    b15  = Buffer.cueSoundFile(s,sfPath15  ,0 ,1);

    //Win
    w = Window("sfPlayer", Rect(130,100,700,522)).front;
    w.view.background = Color.white;
    StaticText(w, Rect(30,492,700,40)).string_("Press space to start a SF (SC selected and cmd-m opens the levelmeter window...) - replay: reselect and press space twice!")
    .font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\left);
    StaticText(w, Rect(30,10,180,30)).string_("A").font_(Font("Arial", 24, true)).stringColor_(Color.black).align_(\center);
    StaticText(w, Rect(230,10,180,30)).string_("B").font_(Font("Arial", 24, true)).stringColor_(Color.black).align_(\center);
    StaticText(w, Rect(430,10,180,30)).string_("C").font_(Font("Arial", 24, true)).stringColor_(Color.black).align_(\center);


    //SynthDef
    SynthDef(\Play1chan,{|bufnum, gain=1 ,mul=1|
        Out.ar(0, VDiskIn.ar( 1, bufnum, rate: 1.0 ) * mul );
        }).send(s);

    SynthDef(\Play2chan,{|bufnum, gain=1 ,mul=1|
        Out.ar(0, VDiskIn.ar( 2, bufnum, rate: 1.0 ) * mul );
        }).send(s);

    //SF-1 button
    dBtext1 = StaticText(w, Rect(165,48.199999999999996,80,20)).string_(dBsf1.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf1 = Button(w, Rect(40,43.199999999999996,140,36))
    .font_(Font("Courir",12))
    .states_([["0-sticks.wav", Color.black],["0-sticks.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf1.value == 0, {
                       b1 = Buffer.cueSoundFile(s,sfPath1,0,2);
                       },{synth_sf1 = Synth.new(\Play2chan,[\bufnum,b1,\mul, dBsf1.dbamp]);button_sf2.focus(true);
                                         })});
    //SF-2 button
    dBtext2 = StaticText(w, Rect(165,98.19999999999999,80,20)).string_(dBsf2.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf2 = Button(w, Rect(40,93.19999999999999,140,36))
    .font_(Font("Courir",12))
    .states_([["1-water-splash.wav", Color.black],["1-water-splash.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf2.value == 0, {
                       b2 = Buffer.cueSoundFile(s,sfPath2,0,2);
                       },{synth_sf2 = Synth.new(\Play2chan,[\bufnum,b2,\mul, dBsf2.dbamp]);button_sf3.focus(true);
                                         })});
    //SF-3 button
    dBtext3 = StaticText(w, Rect(165,148.2,80,20)).string_(dBsf3.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf3 = Button(w, Rect(40,143.2,140,36))
    .font_(Font("Courir",12))
    .states_([["2-machine-noise1.wav", Color.black],["2-machine-noise1.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf3.value == 0, {
                       b3 = Buffer.cueSoundFile(s,sfPath3,0,2);
                       },{synth_sf3 = Synth.new(\Play2chan,[\bufnum,b3,\mul, dBsf3.dbamp]);button_sf4.focus(true);
                                         })});
    //SF-4 button
    dBtext4 = StaticText(w, Rect(165,198.2,80,20)).string_(dBsf4.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf4 = Button(w, Rect(40,193.2,140,36))
    .font_(Font("Courir",12))
    .states_([["3-machine-noise2.wav", Color.black],["3-machine-noise2.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf4.value == 0, {
                       b4 = Buffer.cueSoundFile(s,sfPath4,0,2);
                       },{synth_sf4 = Synth.new(\Play2chan,[\bufnum,b4,\mul, dBsf4.dbamp]);button_sf5.focus(true);
                                         })});
    //SF-5 button
    dBtext5 = StaticText(w, Rect(165,248.2,80,20)).string_(dBsf5.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf5 = Button(w, Rect(40,243.2,140,36))
    .font_(Font("Courir",12))
    .states_([["4-ugly-horn.wav", Color.black],["4-ugly-horn.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf5.value == 0, {
                       b5 = Buffer.cueSoundFile(s,sfPath5,0,2);
                       },{synth_sf5 = Synth.new(\Play2chan,[\bufnum,b5,\mul, dBsf5.dbamp]);button_sf6.focus(true);
                                         })});
    //SF-6 button
    dBtext6 = StaticText(w, Rect(165,298.2,80,20)).string_(dBsf6.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf6 = Button(w, Rect(40,293.2,140,36))
    .font_(Font("Courir",12))
    .states_([["5-crowd.wav", Color.black],["5-crowd.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf6.value == 0, {
                       b6 = Buffer.cueSoundFile(s,sfPath6,0,2);
                       },{synth_sf6 = Synth.new(\Play2chan,[\bufnum,b6,\mul, dBsf6.dbamp]);button_sf7.focus(true);
                                         })});
    //SF-7 button
    dBtext7 = StaticText(w, Rect(165,348.2,80,20)).string_(dBsf7.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf7 = Button(w, Rect(40,343.2,140,36))
    .font_(Font("Courir",12))
    .states_([["6-kung-fu.wav", Color.black],["6-kung-fu.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf7.value == 0, {
                       b7 = Buffer.cueSoundFile(s,sfPath7,0,2);
                       },{synth_sf7 = Synth.new(\Play2chan,[\bufnum,b7,\mul, dBsf7.dbamp]);button_sf8.focus(true);
                                         })});
    //SF-8 button
    dBtext8 = StaticText(w, Rect(165,398.2,80,20)).string_(dBsf8.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf8 = Button(w, Rect(40,393.2,140,36))
    .font_(Font("Courir",12))
    .states_([["7-car-stop.wav", Color.black],["7-car-stop.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf8.value == 0, {
                       b8 = Buffer.cueSoundFile(s,sfPath8,0,2);
                       },{synth_sf8 = Synth.new(\Play2chan,[\bufnum,b8,\mul, dBsf8.dbamp]);button_sf9.focus(true);
                                         })});
    //SF-9 button
    dBtext9 = StaticText(w, Rect(165,448.2,80,20)).string_(dBsf9.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf9 = Button(w, Rect(40,443.2,140,36))
    .font_(Font("Courir",12))
    .states_([["8-children.wav", Color.black],["8-children.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf9.value == 0, {
                       b9 = Buffer.cueSoundFile(s,sfPath9,0,2);
                       },{synth_sf9 = Synth.new(\Play2chan,[\bufnum,b9,\mul, dBsf9.dbamp]);button_sf10.focus(true);
                                         })});
    //SF-10 button
    dBtext10 = StaticText(w, Rect(365,48.199999999999996,80,20)).string_(dBsf10.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf10 = Button(w, Rect(240,43.199999999999996,140,36))
    .font_(Font("Courir",12))
    .states_([["7-car-stop.wav", Color.black],["7-car-stop.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf10.value == 0, {
                       b10 = Buffer.cueSoundFile(s,sfPath10,0,2);
                       },{synth_sf10 = Synth.new(\Play2chan,[\bufnum,b10,\mul, dBsf10.dbamp]);button_sf11.focus(true);
                                         })});
    //SF-11 button
    dBtext11 = StaticText(w, Rect(365,98.19999999999999,80,20)).string_(dBsf11.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf11 = Button(w, Rect(240,93.19999999999999,140,36))
    .font_(Font("Courir",12))
    .states_([["8-children.wav", Color.black],["8-children.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf11.value == 0, {
                       b11 = Buffer.cueSoundFile(s,sfPath11,0,2);
                       },{synth_sf11 = Synth.new(\Play2chan,[\bufnum,b11,\mul, dBsf11.dbamp]);button_sf12.focus(true);
                                         })});
    //SF-12 button
    dBtext12 = StaticText(w, Rect(565,48.199999999999996,80,20)).string_(dBsf12.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf12 = Button(w, Rect(440,43.199999999999996,140,36))
    .font_(Font("Courir",12))
    .states_([["9-car-horn-old.wav", Color.black],["9-car-horn-old.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf12.value == 0, {
                       b12 = Buffer.cueSoundFile(s,sfPath12,0,2);
                       },{synth_sf12 = Synth.new(\Play2chan,[\bufnum,b12,\mul, dBsf12.dbamp]);button_sf13.focus(true);
                                         })});
    //SF-13 button
    dBtext13 = StaticText(w, Rect(565,98.19999999999999,80,20)).string_(dBsf13.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf13 = Button(w, Rect(440,93.19999999999999,140,36))
    .font_(Font("Courir",12))
    .states_([["10-sticks.wav", Color.black],["10-sticks.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf13.value == 0, {
                       b13 = Buffer.cueSoundFile(s,sfPath13,0,2);
                       },{synth_sf13 = Synth.new(\Play2chan,[\bufnum,b13,\mul, dBsf13.dbamp]);button_sf14.focus(true);
                                         })});
    //SF-14 button
    dBtext14 = StaticText(w, Rect(565,148.2,80,20)).string_(dBsf14.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf14 = Button(w, Rect(440,143.2,140,36))
    .font_(Font("Courir",12))
    .states_([["11-camera-noise.wav", Color.black],["11-camera-noise.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf14.value == 0, {
                       b14 = Buffer.cueSoundFile(s,sfPath14,0,1);
                       },{synth_sf14 = Synth.new(\Play1chan,[\bufnum,b14,\mul, dBsf14.dbamp]);button_sf15.focus(true);
                                         })});
    //SF-15 button
    dBtext15 = StaticText(w, Rect(565,198.2,80,20)).string_(dBsf15.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf15 = Button(w, Rect(440,193.2,140,36))
    .font_(Font("Courir",12))
    .states_([["12-alabama.aif", Color.black],["12-alabama.aif",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf15.value == 0, {
                       b15 = Buffer.cueSoundFile(s,sfPath15,0,1);
                       },{synth_sf15 = Synth.new(\Play1chan,[\bufnum,b15,\mul, dBsf15.dbamp]);button_sf15.focus(false);
                                         })});



    //Focus
    button_sf1.focus(true);

    //Set focus color
    button_sf1.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf2.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf3.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf4.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf5.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf6.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf7.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf8.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf9.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf10.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf11.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf12.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf13.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf14.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf15.focusColor  = Color.red(val: 1.0, alpha: 0.8);

    //Close
    w.onClose = {
    b1.free;b2.free;b3.free;b4.free;b5.free;b6.free;b7.free;b8.free;b9.free;b10.free;b11.free;b12.free;b13.free;b14.free;b15.free;
    s.freeAll;
    s.quit;
                };
});
)
