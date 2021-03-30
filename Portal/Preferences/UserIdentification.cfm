<cfparam name="url.showLDAPMailbox"		default="1">

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM UserNames 
WHERE Account = '#SESSION.acc#'
</cfquery>
<style>
    input.button10g:hover{
        background-color: #033F5D!important;
    }
</style>
<cfform onsubmit="return false" name="formsetting">
 	
<table width="97%" align="center" class="formpadding">
	
	<tr><td><h2 style="font-weight: 200;font-size: 24px;color: ##52565B;margin-bottom: 5px;">Your Info</h2></td></tr>
    <tr><td height="8"></td></tr>

	<!---  
   <!--- Field: Account --->
    <TR>
    <TD class="labelmedium" width="200" height="24">Account:</TD>
    <TD>
        <cfoutput query="get">	    
		 #Account# [under: #AccountGroup#] on : <cfoutput>#dateformat(Get.Created, CLIENT.DateFormatShow)#</cfoutput>
	    </cfoutput>
	</TD>
	</TR>	
	--->

    <!--- Field: LastName --->
    <TR>
    <TD style="padding-left:5px" class="labelmedium" height="24"><cf_tl id="LastName">:</TD>
    <TD>
  	    <cfoutput query="get">
		<cfinput class="regularxl" type="Text" name="LastName" id="LastName" value="#lastname#" message="Please enter lastname" required="Yes" size="40" maxlength="40">
		</cfoutput>
    </TD>
	</TR>
	  
    <!--- Field: FirstName --->
    <TR>
    <TD style="padding-left:5px" class="labelmedium" height="24"><cf_tl id="FirstName">:</TD>
    <TD>
	    <cfoutput query="get">
		<cfinput class="regularxl" type="Text" name="FirstName" id="FirstName" value="#firstname#" message="Please enter a firstname" required="Yes" size="30" maxlength="30">
		</cfoutput>
	</TD>
	</TR>
	  
    <!--- Field: FirstName --->
    <TR>
    <TD class="labelmedium" style="padding-left:5px"><cfoutput>#client.IndexNoName#</cfoutput>:</TD>
    <TD class="labelmedium">
  		<cfoutput query="get">
		    <cfif IndexNo eq "">
				<cfinput class="regularxl" type="Text" name="IndexNo" id="IndexNo" value="#IndexNo#" required="No" size="10" maxlength="20">
			<cfelse>
			    #IndexNo#
				<input type="hidden" name="IndexNo" id="IndexNo" value="#IndexNo#">
			</cfif>
		</cfoutput>
	</TD>
	</TR>
			
  	 <!--- Field: eMailExternal --->
    <TR>
    <td style="padding-left:5px" class="labelmedium" height="24"><cf_tl id="Primary"> <cf_tl id="eMail">: </td>
    <TD class="labelmedium">
	    <cfoutput query="get">
		
		 <cfinput type="Text" 
			     name="emailaddress" 
				 id="emailaddress"
				 value="#eMailAddress#" 
				 message="Please enter a valid eMail address" 
				 validate="email" 
				 required="No" 
				 size="30" 
				 maxlength="40" 
				 class="regularxl">
		
		<!---
    	<cfif IndexNo eq "" or eMailAddress eq "">
		     <cfinput type="Text" 
			     name="emailaddress" 
				 id="emailaddress"
				 value="#eMailAddress#" 
				 message="Please enter a valid eMail address" 
				 validate="email" 
				 required="No" 
				 size="30" 
				 maxlength="40" 
				 class="regularxl">
		<cfelse>
		    #eMailAddress#
			<input type="hidden" name="eMailAddress" id="eMailAddress" value="#eMailAddress#">
		</cfif>
		
		--->
		</cfoutput>	
	</TD>
	</TR>
	
  	 <!--- Field: eMailExternal --->
    <TR>
    <TD style="padding-left:5px" class="labelmedium" height="24"><cf_tl id="Secondary"> <cf_tl id="eMail">: </TD>
    <TD class="labelmedium">
    	<cfoutput query="get">
		<cfinput type="Text" name="emailaddressexternal" id="emailaddressexternal" value="#eMailAddressExternal#" message="Please enter a valid eMail address" validate="email" required="No" size="30" maxlength="40" class="regularxl">
		</cfoutput>	
	</TD>
	</TR>
	
		 <!--- Field: eMailExternal --->
    <TR>
    <TD style="padding-left:5px" class="labelmedium" height="24"><cf_tl id="Enterprise UserId">: </TD>
    <TD class="labelmedium">
    	<cfoutput query="get">
		<cfinput type="Text" name="accountno" id="accountno" value="#AccountNo#" required="No" size="20" maxlength="20" class="regularxl">
		</cfoutput>	
	</TD>
	</TR>
	
	
	<cfif url.showLDAPMailbox eq 1>
	
		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Parameter 	
		</cfquery>
							 
			<tr><td style="padding-left:5px" class="labelmedium">
			
				<cfif Check.ExchangeServer neq "">
				Mail box name:&nbsp;&nbsp;
				<cfelse>
				LDAP name:&nbsp;&nbsp;
				</cfif></TD>
			    <TD>
					<cfoutput query="get">
			  		<cfinput class="regularxl" 
					   type="Text" 					   
					   name="mailserveraccount" 
					   id="mailserveraccount"
					   value="#MailServerAccount#" 
					   required="No" 
					   size="50" 
					   maxlength="50">
					</cfoutput>		
				</TD>
			</TR>	
			
		<cfif Check.ExchangeServer neq "">
		
				<tr><td height="10"></td></tr>
			    <tr><td colspan="2" class="labellarge">
					Access Personal Task, schedule information
				</td></tr>
				<tr><td colspan="2" height="1" class="linedotted"></td></tr>
				<tr><td style="height:4"></td></tr>
			
				<!--- Field: FirstName --->
			   <TR>
			    <TD style="padding-left:5px"class="labelmedium"><cf_tl id="Password">:</TD>
			    <TD>
				
				    <table><tr><td>
					<cfoutput query="get">
					
			  		    <cfinput class="regularxl" 
						         type="password" 
								 name="mailserverpassword" 
								 id="mailserverpassword"
								 value="#MailServerPassword#" 
								 required="No" 
								 size="30" 
								 maxlength="30">
					</cfoutput>
					
					</td>
					<td style="padding-left:2px" id="verify">
					
					<cf_tl id="Validate Access" var="vValidate">
					
					<input type="button" 
						name="checkmail" 
						id="checkmail"
						class="button10g"
						style="height:25;width:150"
						value="<cfoutput>#vValidate#</cfoutput>" 						
						onclick="ptoken.navigate('UserMailVerify.cfm?mailbox='+document.getElementById('mailserveraccount').value+'&mailpassword='+document.getElementById('mailserverpassword').value,'verifymail')">
						
					</td>
					
					<td id="verifymail" class="labelmedium2" style="padding-left:6px" colspan="1"></td>
					</tr>
					
					</table>
					
				</TD>
			</TR>
			
		
		</cfif>
		
	<cfelse>
	
		<cfoutput>
			<input type="Hidden" id="mailserveraccount"  name="mailserveraccount"  value="#get.mailserveraccount#">
			<input type="Hidden" id="mailserverpassword" name="mailserverpassword" value="#get.mailserverpassword#">
		</cfoutput>
		
	</cfif>
		
	<tr><td height="2"></td></tr>
	<tr><td height="2"></td></tr>
            <br /><br />
	
	<tr><td height="1" colspan="2">
	
	<cf_tl id="Save" var="vSave">
	
	<cfoutput>
	    <input type="button" name="Save" id="Save" onclick="prefsubmit('identification')" value="#vSave#" class="button10g" style="font-size:14px;line-height: 18px; width:140;height:40;background-color: ##3498db;color: ##ffffff;border:##3498db;position: relative;top: -2px;">
	</cfoutput>
			
	</td></tr>
	
</table>	

</cfform>

<script>
	Prosis.busy('no');	
</script>