
<!--- ------------------------------------- --->
<!--- script loaded for itelliCalendarDate9 --->
<!--- ------------------------------------- --->

<cfoutput>

<script type="text/javascript" src="#SESSION.root#/Scripts/Calendar/js/datepicker.js"></script>

<script language="JavaScript">

	var opts = [];
	
	dtFormat = '#CLIENT.DateFormatShow#'

    function isDate(control) {
		var validSeparator = 0;
		var udt = control.value;
		
	    if(udt.indexOf("/") != -1){
			validSeparator = 1;
		    dt1 = udt.split("/");
		}
		
		if(udt.indexOf("-") != -1){
			validSeparator = 1;
		    dt1 = udt.split("-");
		}
		
		if(udt.indexOf(".") != -1){
			validSeparator = 1;
		    dt1 = udt.split(".");
		}
		
		if (validSeparator == 1) {
		
			if (dtFormat=='dd/mm/yyyy') {
				dd1 = dt1[0];
				mm1 = dt1[1];
				yy1 = dt1[2];
		    } else {
				mm1 = dt1[0];
				dd1 = dt1[1];
				yy1 = dt1[2];
		    }

		    if(isNaN(dd1) || isNaN(mm1) || isNaN(yy1)){
				return false;
		    }
			
			if (yy1 >= 0 && yy1 < 100) { yy1 = parseInt(yy1) + 2000;}
			

		    dt2 = new Date(mm1+'/'+dd1+'/'+yy1)
		
		    dd2 = dt2.getDate();
		    mm2 = dt2.getMonth()+1;
		    yy2 = dt2.getFullYear();			
		
		    if(dd1==dd2 && mm1==mm2 && yy1==yy2){
				
				var vdd = dd2;
				var vmm = mm2;
				var vyy = yy2;
				
				if (vdd < 10) vdd = '0'+vdd;
				if (vmm < 10) vmm = '0'+vmm;
				
			
				if (dtFormat=='dd/mm/yyyy'){
					control.value = vdd + "/" + vmm + "/" + vyy;
				}else{
					control.value = vmm + "/" + vdd + "/" + vyy;
				}
				return true;
				
		    }else{
			
				return false;
				
			}
				
		}else{
			
			return false;
			
		}

    }
	
	function validateDate(control, req, silent) {
	
		control.value = control.value.replace(/ /g,"");
		
		if (req.toLowerCase() == "no" && control.value == "") {
			control.style.backgroundColor = '';
		}else{
			if (isDate(control)) {
				control.style.backgroundColor = '';
			}else{
				control.style.backgroundColor = 'FFB3B3';
				if (silent == 0) alert(control.name + ': not valid date!');
				return false;
			}
		}		
		return true;		
	}

	function pad(value, length) { 
        length = length || 2; 
        return "0000".substr(0,length - Math.min(String(value).length, length)) + value; 
	}
	
   function doCalendar() {
		 for ( i = 0; i< opts.length; i++) {
		 		try{		         
					var single_opts = opts[i];
					datePickerController.createDatePicker(single_opts);
					console.log('disabledDates_'+single_opts.id);
				
					jsonDisabled = eval('disabledDates_'+single_opts.id)
					console.log(jsonDisabled);
					datePickerController.setDisabledDates(single_opts.id,jsonDisabled);
				}
				catch(ex){}
				
					
		}        
   }

</script>

<!--- Add the datepicker's stylesheet --->
<link href="#SESSION.root#/Scripts/Calendar/css/datepicker.css" rel="stylesheet" type="text/css" />
<!--- <link href="#SESSION.root#/tools/Calendar/CalendarScript/css/demo.css" rel="stylesheet" type="text/css" /> --->
	
</cfoutput>	