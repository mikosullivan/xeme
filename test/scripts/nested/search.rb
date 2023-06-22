require 'helper'

# Test searching through nested xemes

class XemeTestSearch < Minitest::Test
  CLASSES = []
  CLASSES << {'clss'=>Xeme, 'cmd'=>'all', 'length'=>726}
  CLASSES << {'clss'=>Xeme::Warning, 'cmd'=>'warnings', 'length'=>121}
  CLASSES << {'clss'=>Xeme::Note, 'cmd'=>'notes', 'length'=>121}
  CLASSES << {'clss'=>Xeme, 'cmd'=>'advisories', 'length'=>242}
  CLASSES << {'clss'=>Xeme::Promise, 'cmd'=>'promises', 'length'=>121}
  CLASSES << {'clss'=>Xeme, 'cmd'=>'errors', 'length'=>242}
  CLASSES << {'clss'=>Xeme, 'cmd'=>'successes', 'length'=>121}
  CLASSES << {'clss'=>Xeme, 'cmd'=>'nils', 'length'=>121}
  
  def test_all
    CLASSES.each do |dfn|
      xeme = Xeme::Nester.create
      assert_equal dfn['length'], xeme.send(dfn['cmd']).length
      assert check_classes(xeme, dfn)
    end
  end
  
  def check_classes(xeme, dfn)
    xeme.send(dfn['cmd']).each do |x|
      if not x.is_a?(dfn['clss'])
        return false
      end
    end
    
    return true
  end
end