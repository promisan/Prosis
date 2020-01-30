
<cfparam name="URL.Id" default="">

<cfquery name="Category" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_IndicatorCategory
</cfquery>
  
<cfquery name="Get" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Indicator
WHERE Code = '#URL.Id#'
</cfquery>

<cfif #Get.Recordcount# eq "0">
<cfset mode = "Insert">
<cfelse>
<cfset mode = "Modify">
</cfif>

<cfoutput>

<HTML><HEAD>
	<TITLE>Indicator #Mode#</TITLE>
</HEAD><body onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

	<cf_ajaxRequest>		
		
	<script language="JavaScript"> 
	
	function doit(action) {
	code     = document.getElementById("code").value
	desc     = document.getElementById("description").value
	ques     = document.getElementById("descriptionquestion").value
	excl     = document.getElementById("exclusive").value
	perc     = document.getElementById("linepercentage").value
	tclr     = document.getElementById("listingcolor").value
	bclr     = document.getElementById("backgroundcolor").value
	order    = document.getElementById("listingorder").value
	
	myaction = action
	url = "RecordSubmit.cfm?ts="+new Date().getTime()+
	             "&code="+code+
				 "&desc="+desc+
				 "&ques="+ques+
				 "&perc="+perc+
				 "&excl="+excl+
				 "&tclr="+tclr+
				 "&bclr="+bclr+
				 "&order="+order+
				 "&action="+action;
	
		AjaxRequest.get({
		        'url':url,
		        'onSuccess':function(req){ 
				    document.getElementById("result").innerHTML = req.responseText;
				    goback()
				   },
							
		        'onError':function(req) { 					      
			     document.getElementById("result").innerHTML = req.responseText;}	
		         }
			 );	
	
	}
	
	function goback() {
		self.returnValue = "go"
		self.close();
		}
		
	function radio(fld,val)	{
		document.getElementById(fld).value = val
	}
	
	</script>

<input type="hidden" name="id" id="id" value="#URL.ID#">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="#MODE#" 
			  banner="yellow" >

<form action="" name="ind" id="ind">

<!--- Entry form --->

<table><tr><td height="1" bgcolor="EAEAEA"></td></tr></table>

<table width="99%" cellspacing="2" cellpadding="2" align="center">

    <TR>
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="code" id="code" value="#Get.Code#" required="Yes" size="4" maxlength="4" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Description:</TD>
    <TD>
  	   <input type="Text" value="#Get.Description#" name="description" id="description" required="Yes" visible="Yes" enabled="Yes" size="80" maxlength="80" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Question:</TD>
    <TD>
  	   <input type="Text" value="#Get.DescriptionQuestion#" name="descriptionquestion" id="descriptionquestion" required="Yes" visible="Yes" enabled="Yes" size="80" maxlength="80" class="regular">
    </TD>
	</TR>
	
	<cfif get.category eq "DSA">
	
	<TR>
    <TD>Deduction:</TD>
    <TD>
  	   <input type="Text"
       name="linepercentage" 
	   id="linepercentage"
       value="#Get.LinePercentage#"
       validate="float"
       required="Yes"
       visible="Yes"
       enabled="Yes"
	   style="text-align:center"
       size="1"
       maxlength="4"
       class="regular">%
    </TD>
	</TR>
	
	<cfelse>
	
	<input type="Hidden"
       name="linepercentage" id="linepercentage"
       value="0">
      	
	</cfif>
						
	<input type="hidden" name="exclusive" id="exclusive" value="<cfif #get.CheckExclusive# neq "0">1<cfelse>0</cfif>">
	  			
	<TR>
    <TD>Pointer Exclusive</TD>
    <TD>
	   <input onclick="radio('exclusive','0')" type="radio" name="checkexclusive" id="checkexclusive" value="0" <cfif #get.CheckExclusive# eq "0">checked</cfif>>No (default)
       <input onclick="radio('exclusive','1')" type="radio" name="checkexclusive" id="checkexclusive" value="1" <cfif #get.CheckExclusive# neq "0">checked</cfif>>Yes
	  </TD>
	</TR>
		  			
	<TR>
    <TD height="25">Interface</TD>
    <TD>
	    #get.LineInterface#
	</TD>
	</TR>
	
	<TR>
    <TD>Text Color:</TD>
    <TD>
  	   <input type="Text"
       name="listingcolor" 
	   id="listingcolor"
       value="#Get.listingbackground#"
       style="text-align:center"
       size="5"
       maxlength="10"
       class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Text Background:</TD>
    <TD>
  	   <input type="Text"
       name="backgroundcolor" 
	   id="backgroundcolor"
       value="#Get.listingbackground#"
       style="text-align:center"
       size="5"
       maxlength="10"
       class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Relative Order:</TD>
    <TD>
  	   <input type="Text"
       name="listingorder" 
	   id="listingorder"
       value="#Get.listingOrder#"
       style="text-align:center"
       size="1"
       maxlength="2"
       class="regular">
    </TD>
	</TR>
	
	<tr><td colspan="2" id="result"></td></tr>
	
</table>

<table width="100%">
<tr><td height="7"></td></tr>
<tr><td height="1" bgcolor="silver"></td></tr>
<tr><td height="7"></td></tr>
</table>

<table width="95%" align="center">	
		
	<td align="center">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="goback()">
	<cfif #Get.recordcount# eq "0">
    <input class="button10g" type="button" name="Insert" value=" Add " onclick="doit('insert')">
	<cfelse>
	<!---
	<input class="buttonFlat" style="width:100" type="button" name="Insert" value=" Delete " onclick="doit('delete')">
	--->
	<input class="button10g" type="button" name="Insert" value=" Save " onclick="doit('modify')">
	</cfif>
	
	</td>	
	
</TABLE>



</cfoutput>

</BODY></HTML>