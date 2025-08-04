<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfoutput>	

<cf_tl id = "Please submit only numeric values" var ="vNumeric">
<cf_tl id = "You should submit a date" var = "vDate">
<cf_tl id = "You have not saved your work." var = "vSave1" class="message"> 
<cf_tl id = "If you click OK, you will lose any unsaved information." var = "vSave2" class="message">  
<cf_tl id = "If you wish to save your information, you should click on Cancel and then click Save" var = "vSave3" class="message">

<cfparam name="CLIENT.location" default="">

<cf_filelibraryscript>

<script>

function isNull(t) {
	 if (t == '')
	 	return 'null'
	 else
	 	return t.replace(',','');
}

function get_data(cl,bg) {
	bg = typeof bg !== 'undefined' ? bg : 0;
		
	var vdata = $(cl);
	var temps = '';
	$(vdata).each(function()
	{	
		 value = isNull($(this).val());
		  if (bg)
		  {
		  		if (value=='null')
					$(this).css({'background-color' : '##FBFDB4'});			
				else
					$(this).css({'background-color' : '##FFFFFF'});		
		  }
		  
		  if (temps == '') {  
		    temps = value;
		  } else {  
		    temps = temps+","+value;
		  }
	});
	return temps;
}

var changes_made = false;


function report_change(e) {
		changes_made = true;
		e.stopPropagation();
		do_bind();
}

function do_bind()
{
	window.onbeforeunload = function() { 
		if (changes_made)
				return '#vSave1# #vSave2# #vSave3#';
	}
}
	
function initConsumption() {


	$("input[id*='_']:input[value='']:text:visible:first").focus();			
		
   	$("input[id*='_']:text:enabled").each(function() {		
		if ($(this).val()=='')
			$(this).css({'background-color' : '##FBFDB4'});		
		else
			$(this).css({'background-color' : '##FFFFFF'});		
     });
	
	
	$(document).off('change','.action');
	$(document).on('change','.action',function(e) {
		if (!changes_made)
			report_change(e);
	});

	$(document).off('keyup','.value,.memo');
	$(document).on('keyup','.value,.memo',function(e) {
		if (!changes_made)
			report_change(e);
	});


	$(document).off('keypress',':text');		 
	$(document).on('keypress',':text', function(e) {
	       if (e.keyCode == 13) {
	          var inputs = $(':text:visible');
	          var idx = inputs.index(this);
	
	          if (idx == inputs.length - 1) {
	                inputs[0].select()
	          } else {
	                inputs[idx + 1].focus(); 
	                inputs[idx + 1].select();
	          }
	            return false;
	      }
	});

}

function get_data_with_names(cl) {

	var vdata = $(cl);
	var temps = '';
	var numeric_error = false;

	$(vdata).each(function() {	
		  value = isNull($(this).val());
		  	
		  if (isNaN(value) && value!='null'){
  			$(this).css({'background-color' : '##F79898'});
			if (!numeric_error)	{
				alert('#vNumeric#');
				$(this).focus();
			}	
			numeric_error = true;						
		  } else
		  {  //no error found
		  	if (value=='null')
		 		$(this).css({'background-color' : '##FBFDB4'});		
			else	
				$(this).css({'background-color' : '##FFFFFF'});		
		  }	
			
		  if (temps == '')   
		    temps = $(this).attr('id')+'_'+value;
	     else  
		    temps = temps+","+$(this).attr('id')+'_'+value;

	});
	
	if (!numeric_error)
		if (temps=='')
			return 'null';
		else
			return temps;
	else
		return false;				
}

function do_save() {
	var vdate = $("##RecordingDate").val();
	if (vdate == ''){
		alert('#vDate#');
		return false;
	} else {
		$("##memos").val(get_data(".memo",true));
		$("##IDS").val(get_data(".aid"));
		$("##HRS").val(get_data(".tid"));
		$("##actions").val(get_data(".action"));
		$("##transactions").val(get_data(".transaction"));
		
		var response = get_data_with_names(".value"); 
		
		if (response) {
			$("##values").val(response);
			$("##fdetails").hide();				
			ColdFusion.navigate('AssetActionFormSubmit.cfm','dreturn','','','POST','fheader')
			$("##fdetails").fadeIn('slow');	

			window.onbeforeunload = null;
			
			changes_made = false;
			$("input[id*='_']:input[value='']:text:visible:first").focus();			
			return true;			
			
		} else
			return false;			
	}			
}

function do_change_date(argObj) {

	var vdate = $("##RecordingDate").val();
	 ColdFusion.navigate('AssetActionFormDate.cfm?adate='+vdate+'&scope=#URL.scope#&mission=#URL.Mission#&Location=#CLIENT.Location#','RecordingDate_trigger');
}			

function maximize(cls,cnt) {
  
  var found = false; 
  $('.'+cls).each(function() {		
		
	if ($(this).is(':visible'))
	{
		$(this).hide();
		$("input[id*='_']:input[value='']:text:visible:first").focus();					
	}	
	else
	{
		$(this).show();	
        if (!found)
			 obj = $(this).find("input[id*='_']:input[value='']:text:visible:first")

		if (obj.length>0 && !found)
		{
		  obj.focus();	
		  found = true;
		} 

	}	
	
   });


 }  	
 
 
function set_time($element,t) {

	$row = $element.parents('tr:first').parents('tr:first');	
	
	if (t=='h')	{
		var vminute = $row.find('select[id*=tdetm_]').val();
		var vtime   = $element.val()+'-'+vminute;
	} else {
		var vhour = $row.find('select[id*=tdeth_]').val();
		var vtime = vhour+'-'+$element.val();	
	}	


    	$row.find('.tid').each(function(){
			$(this).val(vtime);
    	});
		
    	$row.find('.value').each(function(){
			change_id($(this),vtime,$(this).val());
	    });
		
	
}
 
function change_id($element,vtime,vvalue) {
		id = $element.attr('id');
		old_id = id;
		
		str1 = '_[0-9][0-9]*[-][0-9][0-9]_';
		str2 = '_'+vtime+'_';		
		new_id = id.replace(new RegExp(str1, 'g'),str2);	
		
		if ($('##'+new_id).attr('id')) {
			alert('This slot has already been defined, please review your input');	
		} else {
			<cfif find ("MSIE 7","#CGI.HTTP_USER_AGENT#")>
				strInput= '<input type="text" id="'+new_id+'" size="7" maxlength="7" class="value" value="'+vvalue+'"  style="text-align:right;padding-right:3px;width:100%;padding-top:1px;background-color:FBFDB4">';					
				$element.replaceWith(strInput);
			<cfelse>	
				$element.attr('id',new_id);
				if (vvalue == '')
					$element.val('');
			</cfif>
		}	
			
}

 
function new_transaction(cls) {

	start =0;
	$('.'+cls).each(function() {
		$obj = $(this).find('td[id*=hidden]')
		content = $obj.html();
		if (start==0 && content) {
			$first = $(this);	
			start=1;		
		}	
			
		$last = $(this);	
		
		
	});

    var $newRow = $first.clone().insertAfter($last);
	
    //setting proper hour
    previous_hour = $last.find('select[id*=tdeth_]').val();
    if (parseInt(previous_hour)<=23)
                    new_hour = parseInt(previous_hour)+1;
    else
                    new_hour = 23;
                                    
    $newRow.find('select[id*=tdeth_]').val(new_hour);                      
    vtime = new_hour + '-00';

	
	//memo
	
    $newRow.find('.memo').val('');

    $newRow.find('.tid').each(function(){
			$(this).val(vtime);
    });
			
    $newRow.find('.value').each(function(){
		change_id($(this),vtime,'');
    });	

	//add button handling
	original_add = $last.find('td[id*=add_]').html();                                                                
    $last.find('td[id*=add_]').html('');                                                            
 	$newRow.find('td[id*=add_]').html(original_add);
	
    $last.find('td[id*=add_]').html('');                                                  	
	
	
}

function do_change(adate,scope,mission,key,location){	
	var vdate = $("##RecordingDate").val();
	var vcode = $("##sAction").val();

	try{
	var se = window.opener.get_selected_assets();	
	}
	catch (ex){
	var se = 'all';	
	}			
	$("##fdetails").hide();				
	
	ColdFusion.navigate('AssetActionFormDetails.cfm?adate='+vdate+'&code='+vcode+'&assetId='+encodeURIComponent(se)+'&scope='+scope+'&mission='+mission+'&key='+key+'&location='+location,'fdetails');
	$("##fdetails").fadeIn('slow');	
	changes_made = false;
	window.onbeforeunload = null;

}

function do_save_close() {
	if (do_save()) {
		window.onbeforeunload = null;
		window.close();
	}	
}

function edit_details(cat,aid,element)
{
	$row = $(element).parents('tr:first');	
	var vdate = $("##RecordingDate").val();	
	var h = $row.find('select[id*=tdeth_]').val();	
	var m = $row.find('select[id*=tdetm_]').val();

    ret = window.showModalDialog("#SESSION.root#/Warehouse/Application/Stock/Transaction/getAssetEvents.cfm?category="+cat+"&assetid="+aid+"&adate="+vdate+"&hour="+h+"&minute="+m, window, "unadorned:yes; edge:raised; status:yes; dialogHeight:530px; dialogWidth:590px; help:no; scroll:no; center:yes; resizable:no");
	if (ret) {
		
	}			
}

</script>

</cfoutput>	

<style>

.previous {
	background : #F1F1EA;
	font: 11px Verdana, Arial, Helvetica, sans-serif;
}

.current {
	background : #ecf6fc;
	font: bold 11px/24px Verdana, Arial, Helvetica, sans-serif;
}

.title {
	font: bold 18px/24px Calibri, Arial, Helvetica, sans-serif;
	padding-left: 10px;
}

.description {
	font: 10px;
	padding-left: 5px;
}

.subtitle {
	font: bold 10px/24px Verdana, Arial, Helvetica, sans-serif;
}

.itemtitle {
	font: 10px/24px Verdana, Arial, Helvetica, sans-serif;

}

.itemgroup {
	font: 10px;
	padding-left: 5px;
	color: #808080;
	align: left;
}

.itemgroup a {
	font: 10px;
	padding-left: 5px;
	color: #808080;
}


.message {
	font: bold 15px/21px Calibri, Arial, Helvetica, sans-serif;
	color: red;
	padding-left: 10px;
}

.memo, .value {
  border: 1px solid #97B5D2;
}


</style>