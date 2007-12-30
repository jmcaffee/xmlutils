#---
# Test admin login functionality and usernames/passwords for all environments
# 
# 
#---
require 'test/unit'   #(1)
require 'watir'   # the watir controller
require 'cvAppUtils'


class  TestCvAdmin < Test::Unit::TestCase #(3)
  include Watir
  
#-------------------------------------------------------------------------------------------------------------#
# setup - Set up test fixture
#
#------------------------------------------------------------------------------------------------------------#
  def setup
    @configs = CvAdminCfg.new.configs
    @ie = IE.new

    cfg = @configs['head']
    @admin = CvAdmin.new(cfg.url, @ie)
    @admin.login(cfg.name, cfg.pass)

  end
  
#-------------------------------------------------------------------------------------------------------------#
# teardown - Clean up test fixture
#
#------------------------------------------------------------------------------------------------------------#
  def teardown
    @ie.close
  end
  
#-------------------------------------------------------------------------------------------------------------#
# test_addGuideline - Add a guideline and verify that it exists
#
#------------------------------------------------------------------------------------------------------------#
  def test_addGuidelines  #(4)
    testGuidelineList = []
    testGuidelineList[0] = "TestGuideline"
    
    @admin.addGuidelines(testGuidelineList)
    
    # test by attempting to versionAll the guideline:
    @admin.versionAll(testGuidelineList)
    
    assert(@ie.contains_text("Administration"))
  end


#-------------------------------------------------------------------------------------------------------------#
# test_getAppErrorMsg - Test error message retrieval
#
#------------------------------------------------------------------------------------------------------------#
  def test_getAppErrorMsg  
    testGuidelineList = []
    testGuidelineList[0] = "ZZDEP-SUBP-Pricing FIXED Guideline"
    resultMsg = "This guideline is related to other records and may not be deleted."
    
    # test by attempting to delete the guideline:
    @admin.deleteGuidelines(testGuidelineList)
    
    msg = @admin.getAppErrorMsgs()
    assert(resultMsg ==  msg[0])
    
  end


end # test_getAppErrorMsg
