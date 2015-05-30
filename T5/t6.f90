program beOneWithEverything
    implicit none
    integer(kind = 16) :: startingPoint, stepCounter, currentValue

    write(6,'(a)', advance = 'no') '! Give a starting point (integer) for the Collatz adventure: '
    read(5,'(I32)') currentValue
    write(*,*)

    stepCounter = 0

    do
        write(6,'(a)', advance = 'no') '! '
        write(6,*) currentValue
        if(currentValue == 1) then
            exit
        else if(mod(currentValue,2) == 0) then
            currentValue = currentValue/2
        else
            currentValue = currentValue*3 + 1
        end if
        stepCounter = stepCounter + 1
    end do
    write(6,*)
    write(6,'(a)', advance = 'no') '! It took '
    write(6,'(I3)', advance = 'no') stepCounter
    write(6,'(a)') ' steps to reach one.'


end program beOneWithEverything

!Example output:

! Give a starting point (integer) for the Collatz adventure: 214910943194189401384901

!  214910943194189401384901
!  644732829582568204154704
!  322366414791284102077352
!  161183207395642051038676
!  80591603697821025519338
!  40295801848910512759669
!  120887405546731538279008
!  60443702773365769139504
!  30221851386682884569752
!  15110925693341442284876
!  7555462846670721142438
!  3777731423335360571219
!  11333194270006081713658
!  5666597135003040856829
!  16999791405009122570488
!  8499895702504561285244
!  4249947851252280642622
!  2124973925626140321311
!  6374921776878420963934
!  3187460888439210481967
!  9562382665317631445902
!  4781191332658815722951
!  14343573997976447168854
!  7171786998988223584427
!  21515360996964670753282
!  10757680498482335376641
!  32273041495447006129924
!  16136520747723503064962
!  8068260373861751532481
!  24204781121585254597444
!  12102390560792627298722
!  6051195280396313649361
!  18153585841188940948084
!  9076792920594470474042
!  4538396460297235237021
!  13615189380891705711064
!  6807594690445852855532
!  3403797345222926427766
!  1701898672611463213883
!  5105696017834389641650
!  2552848008917194820825
!  7658544026751584462476
!  3829272013375792231238
!  1914636006687896115619
!  5743908020063688346858
!  2871954010031844173429
!  8615862030095532520288
!  4307931015047766260144
!  2153965507523883130072
!  1076982753761941565036
!  538491376880970782518
!  269245688440485391259
!  807737065321456173778
!  403868532660728086889
!  1211605597982184260668
!  605802798991092130334
!  302901399495546065167
!  908704198486638195502
!  454352099243319097751
!  1363056297729957293254
!  681528148864978646627
!  2044584446594935939882
!  1022292223297467969941
!  3066876669892403909824
!  1533438334946201954912
!  766719167473100977456
!  383359583736550488728
!  191679791868275244364
!  95839895934137622182
!  47919947967068811091
!  143759843901206433274
!  71879921950603216637
!  215639765851809649912
!  107819882925904824956
!  53909941462952412478
!  26954970731476206239
!  80864912194428618718
!  40432456097214309359
!  121297368291642928078
!  60648684145821464039
!  181946052437464392118
!  90973026218732196059
!  272919078656196588178
!  136459539328098294089
!  409378617984294882268
!  204689308992147441134
!  102344654496073720567
!  307033963488221161702
!  153516981744110580851
!  460550945232331742554
!  230275472616165871277
!  690826417848497613832
!  345413208924248806916
!  172706604462124403458
!  86353302231062201729
!  259059906693186605188
!  129529953346593302594
!  64764976673296651297
!  194294930019889953892
!  97147465009944976946
!  48573732504972488473
!  145721197514917465420
!  72860598757458732710
!  36430299378729366355
!  109290898136188099066
!  54645449068094049533
!  163936347204282148600
!  81968173602141074300
!  40984086801070537150
!  20492043400535268575
!  61476130201605805726
!  30738065100802902863
!  92214195302408708590
!  46107097651204354295
!  138321292953613062886
!  69160646476806531443
!  207481939430419594330
!  103740969715209797165
!  311222909145629391496
!  155611454572814695748
!  77805727286407347874
!  38902863643203673937
!  116708590929611021812
!  58354295464805510906
!  29177147732402755453
!  87531443197208266360
!  43765721598604133180
!  21882860799302066590
!  10941430399651033295
!  32824291198953099886
!  16412145599476549943
!  49236436798429649830
!  24618218399214824915
!  73854655197644474746
!  36927327598822237373
!  110781982796466712120
!  55390991398233356060
!  27695495699116678030
!  13847747849558339015
!  41543243548675017046
!  20771621774337508523
!  62314865323012525570
!  31157432661506262785
!  93472297984518788356
!  46736148992259394178
!  23368074496129697089
!  70104223488389091268
!  35052111744194545634
!  17526055872097272817
!  52578167616291818452
!  26289083808145909226
!  13144541904072954613
!  39433625712218863840
!  19716812856109431920
!  9858406428054715960
!  4929203214027357980
!  2464601607013678990
!  1232300803506839495
!  3696902410520518486
!  1848451205260259243
!  5545353615780777730
!  2772676807890388865
!  8318030423671166596
!  4159015211835583298
!  2079507605917791649
!  6238522817753374948
!  3119261408876687474
!  1559630704438343737
!  4678892113315031212
!  2339446056657515606
!  1169723028328757803
!  3509169084986273410
!  1754584542493136705
!  5263753627479410116
!  2631876813739705058
!  1315938406869852529
!  3947815220609557588
!  1973907610304778794
!  986953805152389397
!  2960861415457168192
!  1480430707728584096
!  740215353864292048
!  370107676932146024
!  185053838466073012
!  92526919233036506
!  46263459616518253
!  138790378849554760
!  69395189424777380
!  34697594712388690
!  17348797356194345
!  52046392068583036
!  26023196034291518
!  13011598017145759
!  39034794051437278
!  19517397025718639
!  58552191077155918
!  29276095538577959
!  87828286615733878
!  43914143307866939
!  131742429923600818
!  65871214961800409
!  197613644885401228
!  98806822442700614
!  49403411221350307
!  148210233664050922
!  74105116832025461
!  222315350496076384
!  111157675248038192
!  55578837624019096
!  27789418812009548
!  13894709406004774
!  6947354703002387
!  20842064109007162
!  10421032054503581
!  31263096163510744
!  15631548081755372
!  7815774040877686
!  3907887020438843
!  11723661061316530
!  5861830530658265
!  17585491591974796
!  8792745795987398
!  4396372897993699
!  13189118693981098
!  6594559346990549
!  19783678040971648
!  9891839020485824
!  4945919510242912
!  2472959755121456
!  1236479877560728
!  618239938780364
!  309119969390182
!  154559984695091
!  463679954085274
!  231839977042637
!  695519931127912
!  347759965563956
!  173879982781978
!  86939991390989
!  260819974172968
!  130409987086484
!  65204993543242
!  32602496771621
!  97807490314864
!  48903745157432
!  24451872578716
!  12225936289358
!  6112968144679
!  18338904434038
!  9169452217019
!  27508356651058
!  13754178325529
!  41262534976588
!  20631267488294
!  10315633744147
!  30946901232442
!  15473450616221
!  46420351848664
!  23210175924332
!  11605087962166
!  5802543981083
!  17407631943250
!  8703815971625
!  26111447914876
!  13055723957438
!  6527861978719
!  19583585936158
!  9791792968079
!  29375378904238
!  14687689452119
!  44063068356358
!  22031534178179
!  66094602534538
!  33047301267269
!  99141903801808
!  49570951900904
!  24785475950452
!  12392737975226
!  6196368987613
!  18589106962840
!  9294553481420
!  4647276740710
!  2323638370355
!  6970915111066
!  3485457555533
!  10456372666600
!  5228186333300
!  2614093166650
!  1307046583325
!  3921139749976
!  1960569874988
!  980284937494
!  490142468747
!  1470427406242
!  735213703121
!  2205641109364
!  1102820554682
!  551410277341
!  1654230832024
!  827115416012
!  413557708006
!  206778854003
!  620336562010
!  310168281005
!  930504843016
!  465252421508
!  232626210754
!  116313105377
!  348939316132
!  174469658066
!  87234829033
!  261704487100
!  130852243550
!  65426121775
!  196278365326
!  98139182663
!  294417547990
!  147208773995
!  441626321986
!  220813160993
!  662439482980
!  331219741490
!  165609870745
!  496829612236
!  248414806118
!  124207403059
!  372622209178
!  186311104589
!  558933313768
!  279466656884
!  139733328442
!  69866664221
!  209599992664
!  104799996332
!  52399998166
!  26199999083
!  78599997250
!  39299998625
!  117899995876
!  58949997938
!  29474998969
!  88424996908
!  44212498454
!  22106249227
!  66318747682
!  33159373841
!  99478121524
!  49739060762
!  24869530381
!  74608591144
!  37304295572
!  18652147786
!  9326073893
!  27978221680
!  13989110840
!  6994555420
!  3497277710
!  1748638855
!  5245916566
!  2622958283
!  7868874850
!  3934437425
!  11803312276
!  5901656138
!  2950828069
!  8852484208
!  4426242104
!  2213121052
!  1106560526
!  553280263
!  1659840790
!  829920395
!  2489761186
!  1244880593
!  3734641780
!  1867320890
!  933660445
!  2800981336
!  1400490668
!  700245334
!  350122667
!  1050368002
!  525184001
!  1575552004
!  787776002
!  393888001
!  1181664004
!  590832002
!  295416001
!  886248004
!  443124002
!  221562001
!  664686004
!  332343002
!  166171501
!  498514504
!  249257252
!  124628626
!  62314313
!  186942940
!  93471470
!  46735735
!  140207206
!  70103603
!  210310810
!  105155405
!  315466216
!  157733108
!  78866554
!  39433277
!  118299832
!  59149916
!  29574958
!  14787479
!  44362438
!  22181219
!  66543658
!  33271829
!  99815488
!  49907744
!  24953872
!  12476936
!  6238468
!  3119234
!  1559617
!  4678852
!  2339426
!  1169713
!  3509140
!  1754570
!  877285
!  2631856
!  1315928
!  657964
!  328982
!  164491
!  493474
!  246737
!  740212
!  370106
!  185053
!  555160
!  277580
!  138790
!  69395
!  208186
!  104093
!  312280
!  156140
!  78070
!  39035
!  117106
!  58553
!  175660
!  87830
!  43915
!  131746
!  65873
!  197620
!  98810
!  49405
!  148216
!  74108
!  37054
!  18527
!  55582
!  27791
!  83374
!  41687
!  125062
!  62531
!  187594
!  93797
!  281392
!  140696
!  70348
!  35174
!  17587
!  52762
!  26381
!  79144
!  39572
!  19786
!  9893
!  29680
!  14840
!  7420
!  3710
!  1855
!  5566
!  2783
!  8350
!  4175
!  12526
!  6263
!  18790
!  9395
!  28186
!  14093
!  42280
!  21140
!  10570
!  5285
!  15856
!  7928
!  3964
!  1982
!  991
!  2974
!  1487
!  4462
!  2231
!  6694
!  3347
!  10042
!  5021
!  15064
!  7532
!  3766
!  1883
!  5650
!  2825
!  8476
!  4238
!  2119
!  6358
!  3179
!  9538
!  4769
!  14308
!  7154
!  3577
!  10732
!  5366
!  2683
!  8050
!  4025
!  12076
!  6038
!  3019
!  9058
!  4529
!  13588
!  6794
!  3397
!  10192
!  5096
!  2548
!  1274
!  637
!  1912
!  956
!  478
!  239
!  718
!  359
!  1078
!  539
!  1618
!  809
!  2428
!  1214
!  607
!  1822
!  911
!  2734
!  1367
!  4102
!  2051
!  6154
!  3077
!  9232
!  4616
!  2308
!  1154
!  577
!  1732
!  866
!  433
!  1300
!  650
!  325
!  976
!  488
!  244
!  122
!  61
!  184
!  92
!  46
!  23
!  70
!  35
!  106
!  53
!  160
!  80
!  40
!  20
!  10
!  5
!  16
!  8
!  4
!  2
!  1

! It took 605 steps to reach one.

