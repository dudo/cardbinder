class CardSet
  include Mongoid::Document
  include Mongoid::Slug

  field :name, type: String
  slug :name
  field :code, type: String # The code name of the set
  field :gathererCode, type: String # The code that Gatherer uses for the set. Only present if different than 'code'
  field :releaseDate, type: Date
  field :type, type: String # Type of set. One of: "core", "expansion"
  field :block, type: String

  has_many :cards

  index(code: 1)
  index(releaseDate: 1)

  NON_STANDARD_SETS = %w(CED CEI pDRC pLGM pMEI MGB pMGD pJGP pPRE PTK pARL S00 DKM
                         pALP VAN pWOR PO2 ATH POR CHR pPOD ITP RQS pGRU pCEL UGL
                         CEI CED ME2 pWPN DD2 DDC V09 HOP ME3 DDD H09 DDE DPA ARC
                         V10 DDF PD2 ME4 DDG CMD V11 DDH PD3 DDI PC2 V12 DDJ CM1
                         DDK pWCQ MMA V13 DDL C13 DDM MD1 CPK CNS VMA V14 DDN DD3_DVD DD3_EVG
                         C14 S99 DD3_GVL DD3_JVC FRF_UGIN DDO pWOS TPR MM2 DDP
                         V15 C15 W16 DDQ EMA EVG p15A BRB DRB pLPA pSUM MED pGPX pHHO pPRO
                         CST pCMP UNH pGTW p2HG pSUS pREL pFNM pMPR BTD pELP)
  DONT_HAVE_PICS = %w(M15 KTK FRF DTK BFZ OGW EXP ORI SOI EMN)

end