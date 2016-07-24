Pod::Spec.new do |s|
  s.name         = 'HQQWaterFlow'
  s.version      = '1.0.0'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/huangqiangqiang/HQQWaterFlowView'
  s.authors      = 'QIANGQIANG HUANG': '285086598@163.com'
  s.summary      = 'WaterFlowView Framework'

  s.platform     =  :ios, 'iOS 7.0'
  s.source       =  git: 'git@github.com:huangqiangqiang/HQQWaterFlowView.git', :tag => s.version
  s.source_files = 'HQQWaterFlow/HQQWaterFlowView/*.{h,m}'
  s.requires_arc = true
  
# Pod Dependencies

end