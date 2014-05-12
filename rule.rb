rule_register :normal do
  f(/name/).val("毛先生")
  f(/company/).val("深圳市米兰时尚设计培训中心有限公司");
  f(/username/).val("mcaitaly")
  f(/passw(or)?d/).val("mh960205");
  f(/email/).val(R("email"));
  f(/telephone/).val(R("telephone"));
end

rule_register /.*/ do  
  include :normal
end

rule_register /ihuceba\.php/ do
  include :normal
  j("#type").val("企业单位");
end

rule_new :normal do
  f(/telephone/).val(R("telephone"));
end

rule_new /liebiao\.com/ do
  s(/业余班/).attr('checked', 'checked')
  st(/服装设计/).parent.val(3)
  j(".con-textarea").val(R("content")).trigger("change").trigger("blur")
  j("input[size=20]").filter("input[class*='txt']").filter("input[maxlength=18]").filter("input[type='text']").val(R("mobile")).trigger("change").trigger("blur")
  j("input[maxlength=30]").filter("input[class*='txt']").filter("input[type='text']").val(R("title")).trigger("change").trigger("blur")
  j("input[size=20]").filter("input[class*='txt']").filter("input[maxlength=4]").filter("input[type='text']").val("宋老师").trigger("change").trigger("blur")
end

