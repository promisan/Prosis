
<!---
<div id="sessionvalid" style="width:0px; height:0px; line-height:0px; font:0px;"></div>
<div id="sessionvalidcheck" style="width:0px; height:0px; line-height:0px; font:0px;"></div>
--->

<cfparam name="attributes.doctypemode" default="quirks">

<cfquery name="System" 
	datasource="AppsSystem">
	SELECT *  
	FROM   Parameter
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#CGI.HTTP_HOST#'
</cfquery>

<cfset interval = "#Parameter.SessionProtectionInterval*1000#">
	
<cfif CGI.HTTPS eq "off">
	<cfset tpe = "http">
<cfelse>	
	<cfset tpe = "https">
</cfif>
			
<script language="JavaScript">

	var cacc   = "<cfoutput>#SESSION.acc#</cfoutput>"
	var dtpe   = "<cfoutput>#attributes.doctypemode#</cfoutput>"
	var spth   = "<cfoutput>#tpe#://#CGI.HTTP_HOST#/#System.VirtualDirectory#</cfoutput>"	
	var tmp_error = 0;
		
	// -------------------------------------------------------------------------------------------	
	// this is the method for starting the validation check once the authentication is there again
	// -------------------------------------------------------------------------------------------
	
	function sessioninitvalidatestop() {		
		try { clearInterval ( sessioninitcheck ); } catch(e) {}												
	}		
	
	function sessioninitvalidatestart() {			   			    			    		     
		try { clearInterval ( sessioninitcheck ); } catch(e) {}	  
		<cfif interval gte "1000">							 
	    try { sessioninitcheck = setInterval('validationcheck()', 3000) } catch(e) { }											
		</cfif>
	}	
		
	function validationcheck()	 { 			   			
		_cf_loadingtexthtml="";			    								
	    ptoken.navigate(spth+'/Tools/Control/validateSessionStart.cfm?acc='+cacc,'sessionvalidcheck',sessioninitsuccesshandler,sessioninitfailhandler);				
		_cf_loadingtexthtml="<cfoutput><div><img src='#SESSION.root#/images/busy11.gif'/></cfoutput>";				 				
	}	
	
	 var sessioninitsuccesshandler = function(errorCode,errorMessage){	   
        // sessioninitvalidatestop();
     } 	
	
	 var sessioninitfailhandler = function(errorCode,errorMessage){	   
        sessioninitvalidatestop();
    } 
		
	// ------------------------------------------------------------------------------------------
	// this is the method for performing the valid check when validation is considered granted 										
	// -------------------------------------------------------------------------------------------
	 
	
	function sessionvalidatestart() {		
	    								
		try { clearInterval ( sessioncheck ); } catch(e) {}	  		
		<cfif interval gte "1000">				 
	    try { sessioncheck = setInterval('validationgo()', <cfoutput>#interval#</cfoutput>) } catch(e) {}											
		</cfif>	
								
	}		
	
	function sessionvalidatestop() {						    			    		     
		try { clearInterval ( sessioncheck ); } catch(e) {}			
										
	}					
	
	function validationgo()	 { 			  
		 					
		_cf_loadingtexthtml="";	  
		// stop the interval
		sessionvalidatestop()   			
		// perform validation 		
		ColdFusion.navigate(spth+'/Tools/Control/validateSession.cfm?doctypemode='+dtpe+'&passacc='+cacc,'sessionvalid',sessionsuccesshandler,sessionfailhandler);	
		// restart interval if successfull
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";		
			
	}
	
	var sessionsuccesshandler = function(){	
	    // we restart the interval but NOT if the logon modal dialog has been shown			
		if (tmp_error == 0)
			sessionvalidatestart()	 
    } 
	
	var sessionfailhandler = function(errorCode,errorMessage){	
	     // we stop the interval 		
		 tmp_error =1;
         sessionvalidatestop();		 
    } 

</script>	
