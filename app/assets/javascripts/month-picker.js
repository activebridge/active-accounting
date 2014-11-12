/*

The jQuery UI Month Picker Version 2.2

https://github.com/KidSysco/jquery-ui-month-picker/

Minified at http://closure-compiler.appspot.com/home

https://github.com/KidSysco/jquery-ui-month-picker/
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation;
version 3.0. This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.
You should have received a copy of the GNU Lesser General Public
License along with this library; if not, visit
http://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt.

*/
(function(a,g,e,f){a.MonthPicker={i18n:{year:"Рік",prevYear:"Попередній рік",nextYear:"Наступний рік",next5Years:"Перейти 5 вперед",prev5Years:"Перейти 5 назад",nextLabel:"Вперед",prevLabel:"Назад",buttonText:"Open Month Chooser",jumpYears:"Вибрати рік",months:"Січ. Лют. Бер. Кві. Тра. Чер. Лип. Сер. Вер. Жов. Лис. Груд.".split(" ")}};a.widget("KidSysco.MonthPicker",{options:{i18n:null,StartYear:null,ShowIcon:!0,UseInputMask:!1,ValidationErrorMessage:null,Disabled:!1,OnAfterMenuOpen:null,OnAfterMenuClose:null,
OnAfterNextYear:null,OnAfterNextYears:null,OnAfterPreviousYear:null,OnAfterPreviousYears:null,OnAfterChooseMonth:null,OnAfterChooseYear:null,OnAfterChooseYears:null,OnAfterChooseMonths:null},_monthPickerMenu:null,_monthPickerButton:null,_validationMessage:null,_yearContainer:null,_isMonthInputType:null,_enum:{_overrideStartYear:"MonthPicker_OverrideStartYear"},_destroy:function(){jQuery.mask&&this.options.UseInputMask&&this.element.unmask();this.element.val("").css("color","").removeClass("month-year-input").removeData(this._enum._overrideStartYear).unbind();
a(e).unbind("click.MonthPicker"+this.element.attr("id"),a.proxy(this._hide,this));this._monthPickerMenu.remove();this._monthPickerMenu=null;this.monthPickerButton&&(this._monthPickerButton.remove(),this._monthPickerButton=null);this._validationMessage&&(this._validationMessage.remove(),this._validationMessage=null)},_setOption:function(b,c){this._super("_setOption",b,c);switch(b){case "i18n":this.options.i18n=a.extend({},c);break;case "Disabled":this.options.Disabled=c;this._setDisabledState();break;
case "OnAfterChooseMonth":this.options.OnAfterChooseMonth=c;break;case "OnAfterChooseMonths":this.options.OnAfterChooseMonths=c;break;case "OnAfterChooseYear":this.options.OnAfterChooseYear=c;break;case "OnAfterChooseYears":this.options.OnAfterChooseYears=c;break;case "OnAfterMenuClose":this.options.OnAfterMenuClose=c;break;case "OnAfterMenuOpen":this.options.OnAfterMenuOpen=c;break;case "OnAfterNextYear":this.options.OnAfterNextYear=c;break;case "OnAfterNextYears":this.options.OnAfterNextYears=c;
break;case "OnAfterPreviousYear":this.options.OnAfterPreviousYear=c;break;case "OnAfterPreviousYears":this.options.OnAfterPreviousYears=c;break;case "UseInputMask":this.options.UseInputMask=c;this._setUseInputMask();break;case "StartYear":this.options.StartYear=c;this._setStartYear();null!==c&&this._setPickerYear(c);break;case "ShowIcon":this.options.ShowIcon=c;this._showIcon();break;case "ValidationErrorMessage":this.options.ValidationErrorMessage=c,null!==this.options.ValidationErrorMessage?this._createValidationMessage():
this._removeValidationMessage()}},_init:function(){if(!jQuery.ui||!jQuery.ui.button||!jQuery.ui.datepicker)return alert("MonthPicker Setup Error: The jQuery UI button and datepicker plug-ins must be loaded before MonthPicker is called."),!1;if(!this.element.is('input[type="text"]')&&!this.element.is('input[type="month"]'))return alert("MonthPicker Setup Error: MonthPicker can only be called on text or month inputs. "+this.element.attr("id")+" is not a text or month input."),!1;if(!jQuery.mask&&this.options.UseInputMask)return alert("MonthPicker Setup Error: The UseInputMask option is set but the Digital Bush Input Mask jQuery Plugin is not loaded. Get the plugin from http://digitalbush.com/"),
!1;this.element.is('input[type="month"]')?(this.element.css("width","auto"),this._isMonthInputType=!0):this._isMonthInputType=!1;this.element.addClass("month-year-input");this._setStartYear();this._monthPickerMenu=a('<div id="MonthPicker_'+this.element.attr("id")+'" class="month-picker ui-helper-clearfix"></div>');a('<div class="ui-widget-header ui-helper-clearfix ui-corner-all"><table class="month-picker-year-table" width="100%" border="0" cellspacing="1" cellpadding="2"><tr><td class="previous-year"><button>&nbsp;</button></td><td class="year-container-all"><div class="year-title"></div><div id="year-container"><span class="year"></span></div></td><td class="next-year"><button>&nbsp;</button></td></tr></table></div><div class="ui-widget ui-widget-content ui-helper-clearfix ui-corner-all"><table class="month-picker-month-table" width="100%" border="0" cellspacing="1" cellpadding="2"><tr><td><button type="button" class="button-1"></button></td><td><button class="button-2" type="button"></button></td><td><button class="button-3" type="button"></button></td></tr><tr><td><button class="button-4" type="button"></button></td><td><button class="button-5" type="button"></button></td><td><button class="button-6" type="button"></button></td></tr><tr><td><button class="button-7" type="button"></button></td><td><button class="button-8" type="button"></button></td><td><button class="button-9" type="button"></button></td></tr><tr><td><button class="button-10" type="button"></button></td><td><button class="button-11" type="button"></button></td><td><button class="button-12" type="button"></button></td></tr></table></div>').appendTo(this._monthPickerMenu);
a("body").append(this._monthPickerMenu);this._monthPickerMenu.find(".year-title").text(this._i18n("year"));this._monthPickerMenu.find(".year-container-all").attr("title",this._i18n("jumpYears"));this._showIcon();this._createValidationMessage();this._yearContainer=a(".year",this._monthPickerMenu);a(".previous-year button",this._monthPickerMenu).button({icons:{primary:"ui-icon-circle-triangle-w"},text:!1});a(".previous-year button span.ui-button-icon-primary").text(this._i18n("prevLabel"));a(".next-year button",
this._monthPickerMenu).button({icons:{primary:"ui-icon-circle-triangle-e"},text:!1});a(".next-year button span.ui-button-icon-primary").text(this._i18n("nextLabel"));a(".month-picker-month-table td button",this._monthPickerMenu).button();a(".year-container-all",this._monthPickerMenu).click(a.proxy(this._showYearsClickHandler,this));a(e).bind("click.MonthPicker"+this.element.attr("id"),a.proxy(this._hide,this));this._monthPickerMenu.bind("click.MonthPicker",function(b){return!1});this._setUseInputMask();
this._setDisabledState()},_i18n:function(b){return a.extend({},a.MonthPicker.i18n,this.options.i18n)[b]},_isFunction:function(b){return"function"===typeof b},GetSelectedYear:function(){return this._validateYear(this.element.val())},GetSelectedMonth:function(){return this._validateMonth(this.element.val())},GetSelectedMonthYear:function(){var b=this._validateMonth(this.element.val()),c=this._validateYear(this.element.val());if(isNaN(c)||isNaN(b))return null===this.options.ValidationErrorMessage||this.options.Disabled||
a("#MonthPicker_Validation_"+this.element.attr("id")).show(),null;null===this.options.ValidationErrorMessage||this.options.Disabled||a("#MonthPicker_Validation_"+this.element.attr("id")).hide();b=this._isMonthInputType?c+"-"+b:b+"/"+c;a(this).val(b);return b},Disable:function(){this._setOption("Disabled",!0)},Enable:function(){this._setOption("Disabled",!1)},ClearAllCallbacks:function(){this.options.OnAfterChooseMonth=null;this.options.OnAfterChooseMonths=null;this.options.OnAfterChooseYear=null;
this.options.OnAfterChooseYears=null;this.options.OnAfterMenuClose=null;this.options.OnAfterMenuOpen=null;this.options.OnAfterNextYear=null;this.options.OnAfterNextYears=null;this.options.OnAfterPreviousYear=null;this.options.OnAfterPreviousYears=null},Clear:function(){this.element.val("");null!==this._validationMessage&&this._validationMessage.hide()},_showIcon:function(){null===this._monthPickerButton?this.options.ShowIcon?(this._monthPickerButton=a('<span id="MonthPicker_Button_'+this.element.attr("id")+
'" class="month-picker-open-button">'+this._i18n("buttonText")+"</span>").insertAfter(this.element),this._monthPickerButton.button({text:!1,icons:{primary:"ui-icon-calculator"}}).click(a.proxy(this._show,this))):this.element.bind("click.MonthPicker",a.proxy(this._show,this)):this.options.ShowIcon||(this._monthPickerButton.remove(),this._monthPickerButton=null,this.element.bind("click.MonthPicker",a.proxy(this._show,this)))},_createValidationMessage:function(){null!==this.options.ValidationErrorMessage&&
""!==this.options.ValidationErrorMessage&&(this._validationMessage=a('<span id="MonthPicker_Validation_'+this.element.attr("id")+'" class="month-picker-invalid-message">'+this.options.ValidationErrorMessage+"</span>"),this._validationMessage.insertAfter(this.options.ShowIcon?this.element.next():this.element),this.element.blur(a.proxy(this.GetSelectedMonthYear,this)))},_removeValidationMessage:function(){null===this.options.ValidationErrorMessage&&(this._validationMessage.remove(),this._validationMessage=
null)},_show:function(){var b=this.GetSelectedYear();this.element.data(this._enum._overrideStartYear)!==f?this._setPickerYear(this.options.StartYear):isNaN(b)?this._setPickerYear((new Date).getFullYear()):this._setPickerYear(b);if("none"===this._monthPickerMenu.css("display")){var b=this.element.offset().top+this.element.height()+7,c=this.element.offset().left;this._monthPickerMenu.css({top:b+"px",left:c+"px"}).slideDown(500,a.proxy(function(){this._isFunction(this.options.OnAfterMenuOpen)&&this.options.OnAfterMenuOpen()},
this))}this._showMonths();return!1},_hide:function(){"block"===this._monthPickerMenu.css("display")&&this._monthPickerMenu.slideUp(500,a.proxy(function(){this._isFunction(this.options.OnAfterMenuClose)&&this.options.OnAfterMenuClose()},this))},_setUseInputMask:function(){if(!this._isMonthInputType)try{this.options.UseInputMask?this.element.mask("99/9999"):this.element.unmask()}catch(b){}},_setDisabledState:function(){this.options.Disabled?(this.element.prop("disabled",!0),this.element.addClass("month-picker-disabled"),
null!==this._monthPickerButton&&this._monthPickerButton.button("option","disabled",!0),null!==this._validationMessage&&this._validationMessage.hide()):(this.element.prop("disabled",!1),this.element.removeClass("month-picker-disabled"),null!==this._monthPickerButton&&this._monthPickerButton.button("option","disabled",!1))},_setStartYear:function(){null!==this.options.StartYear?this.element.data(this._enum._overrideStartYear,!0):this.element.removeData(this._enum._overrideStartYear)},_getPickerYear:function(){return parseInt(this._yearContainer.text(),
10)},_setPickerYear:function(b){this._yearContainer.text(b)},_validateMonth:function(b){if(""===b)return NaN;if(-1!=b.indexOf("/")){var a=parseInt(b.split("/")[0],10);if(!isNaN(a)&&1<=a&&12>=a)return a}return-1!=b.indexOf("-")&&(a=parseInt(b.split("-")[1],10),!isNaN(a)&&1<=a&&12>=a)?a:NaN},_validateYear:function(a){if(""===a)return NaN;if(-1!=a.indexOf("/")){var c=parseInt(a.split("/")[1],10);if(!isNaN(c)&&1800<=c&&3E3>=c)return c}return-1!=a.indexOf("-")&&(c=parseInt(a.split("-")[0],10),!isNaN(c)&&
1800<=c&&3E3>=c)?c:NaN},_chooseMonth:function(a){0<a&&10>a&&(a="0"+a);this.element.is('input[type="month"]')?this.element.val(this._getPickerYear()+"-"+a).change():this.element.val(a+"/"+this._getPickerYear()).change();this.element.blur();this._isFunction(this.options.OnAfterChooseMonth)&&this.options.OnAfterChooseMonth()},_chooseYear:function(a){this._setPickerYear(a);this._showMonths();this._isFunction(this.options.OnAfterChooseYear)&&this.options.OnAfterChooseYear()},_showMonths:function(){var b=
this._i18n("months");a(".previous-year button",this._monthPickerMenu).attr("title",this._i18n("prevYear")).unbind("click").bind("click.MonthPicker",a.proxy(this._previousYear,this));a(".next-year button",this._monthPickerMenu).attr("title",this._i18n("nextYear")).unbind("click").bind("click.MonthPicker",a.proxy(this._nextYear,this));a(".year-container-all",this._monthPickerMenu).css("cursor","pointer");a(".month-picker-month-table button",this._monthPickerMenu).unbind(".MonthPicker");for(var c in b){var d=
parseInt(c,10)+1;a(".button-"+d,this._monthPickerMenu).bind("click.MonthPicker",{_month:d},a.proxy(function(a){this._chooseMonth(a.data._month);this._hide()},this));a(".button-"+d,this._monthPickerMenu).button("option","label",b[c])}},_showYearsClickHandler:function(){this._showYears();this._isFunction(this.options.OnAfterChooseYears)&&this.options.OnAfterChooseYears()},_showYears:function(){var b=this._getPickerYear();a(".previous-year button",this._monthPickerMenu).attr("title",this._i18n("prev5Years")).unbind("click").bind("click",
a.proxy(function(){this._previousYears();return!1},this));a(".next-year button",this._monthPickerMenu).attr("title",this._i18n("next5Years")).unbind("click").bind("click",a.proxy(function(){this._nextYears();return!1},this));a(".year-container-all",this._monthPickerMenu).css("cursor","default");a(".month-picker-month-table button",this._monthPickerMenu).unbind(".MonthPicker");for(var c=-4,d=1;12>=d;d++)a(".button-"+d,this._monthPickerMenu).bind("click.MonthPicker",{_yearDiff:c},a.proxy(function(a){this._chooseYear(b+
a.data._yearDiff)},this)),a(".button-"+d,this._monthPickerMenu).button("option","label",b+c),c++},_nextYear:function(){var b=a(".month-picker-year-table .year",this._monthPickerMenu);b.text(parseInt(b.text())+1,10);this._isFunction(this.options.OnAfterNextYear)&&this.options.OnAfterNextYear()},_nextYears:function(){var b=a(".month-picker-year-table .year",this._monthPickerMenu);b.text(parseInt(b.text())+5,10);this._showYears();this._isFunction(this.options.OnAfterNextYears)&&this.options.OnAfterNextYears()},
_previousYears:function(){var b=a(".month-picker-year-table .year",this._monthPickerMenu);b.text(parseInt(b.text())-5,10);this._showYears();this._isFunction(this.options.OnAfterPreviousYears)&&this.options.OnAfterPreviousYears()},_previousYear:function(){var b=a(".month-picker-year-table .year",this._monthPickerMenu);b.text(parseInt(b.text())-1,10);this._isFunction(this.options.OnAfterPreviousYear)&&this.options.OnAfterPreviousYear()}})})(jQuery,window,document);
