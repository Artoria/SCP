 var fuzzyId = function(id){
     var f = document.getElementsByTagName("input")
     var ret = []
     for(var i = 0; i < f.length; ++i){
        if(f[i].id.match(id)){
            ret.push(f[i]);
        }
     }
     return window.jQuery(ret);
  }

  var selectVal = function(val){
     var f = document.getElementsByTagName("input")
     var ret = []
     for(var i = 0; i < f.length; ++i){
        if(f[i].val.match(val)){
            ret.push(f[i]);
        }
     }
     return window.jQuery(ret);
  }

  var getText = function(el){
    if(el && el.textContent) return el.textContent;
    if(el && el.innerText) return el.innerText;
    return ""
  }

  var selectText = function(text){
     var f = document.getElementsByTagName("input")
     var ret = []
     for(var i = 0; i < f.length; ++i){
        if(getText(f[i]).match(text)){
            ret.push(f[i]);
        }
     }
     var f = document.getElementsByTagName("label")
     var ret = []
     for(var i = 0; i < f.length; ++i){
        if(getText(f[i]).match(text)){
            ret.push(document.getElementById(f[i].getAttribute('for')));
        }
     }    
     return window.jQuery(ret);
  }
  var selectByText = function(text){
     var rs = $("*").contents().filter(function(){
       return this.nodeType === 3 && this.nodeValue.match(text);
     })
     return rs.parent();
  }