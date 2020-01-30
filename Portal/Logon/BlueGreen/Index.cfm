<!--- saved from url=(0014)about:internet --->
<html>
<head>
<title>Prosis� Powerful Solutions with a Human Touch</title>
<meta http-equiv="Content-Type" content="text/html;">
<!--Fireworks 8 Dreamweaver 8 target.  Created Mon Apr 17 15:45:11 GMT-0600 2006-->
<style type="text/css">
<!--
.style5 {color: #003366}
.style1 {	color: #FFFFFF;
	font-weight: bold;
	font-size: 35px;
}
.style2 {	color: #FFFFFF;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style4 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-weight: bold;
	color: #FFFFFF;
}
.style6 {font-family: Verdana, Arial, Helvetica, sans-serif}
.style8 {font-size: 14px}
.style7 {font-size: 9px}
-->
</style>
</head>

<cfoutput>

<cfset client.context = "main">		
<cfset path = "Portal/Logon/Bluegreen/">

<cfif Parameter.applicationServer eq "SECAP_901">
  <cfset color = "silver">
<cfelse>
  <cfset color = "485460">
</cfif>

<body bgcolor="#color#" onload="javascript:document.forms.loginform.password.focus();">
<div align="center">
  <table border="0" cellpadding="0" cellspacing="0" width="801">
    <tr>
      <td width="14"></td>
      <td width="207"></td>
      <td width="244"></td>
      <td width="320"></td>
      <td width="15"></td>
      <td width="1"></td>
    </tr>
    
    <tr>
      <td colspan="5" background="#path#index_r1_c1.jpg"> </td>
      <td width="1" height="59"></td>
    </tr>
    <tr>
      <td rowspan="6" background="#path#index_r2_c1.jpg"> </td>
      <td background="#path#index_r2_c2.jpg"> </td>
      <td class="def" background="#path#index_r2_c3.jpg"><div align="left"><FONT face="Georgia, Times New Roman, Times, serif" 
            size=1><STRONG><cfoutput>release #CLIENT.Version#</STRONG> [#client.release#]</cfoutput></FONT><FONT 
            face="Georgia, Times New Roman, Times, serif" color=336699 
            size=1><FONT color=3399ff> </FONT><FONT color=8ea4bb> <BR>
        </FONT></FONT><FONT 
            face="Georgia, Times New Roman, Times, serif" 
            size=1> <span class="style5">
			<cfoutput>#SESSION.authorMemo#</cfoutput> <br>
				<cfoutput>#CLIENT.Manager#</cfoutput>
			 </span></FONT></div></td>
      <td background="#path#index_r2_c4.jpg"> </td>
      <td rowspan="6" background="#path#index_r2_c5.jpg"> </td>
      <td width="1" height="50"></td>
    </tr>
    <tr>
      <td background="#path#index_r3_c2.jpg"> </td>
      <td background="#path#index_r3_c3.jpg"> </td>
      <td background="#path#index_r3_c4.jpg"> </td>
      <td width="1" height="120"></td>
    </tr>
    <tr>
      <td background="#path#index_r4_c2.jpg"> </td>
      <td colspan="2" background="#path#index_r4_c3.jpg"><div align="right"><span class="style1"><font face="Staccato222 BT"><cfoutput>#SESSION.welcome#&nbsp;&nbsp;</cfoutput></span></div></font></td>
      <td width="1" height="41"></td>
    </tr>
    <tr>
      <td background="#path#index_r5_c2.jpg"> </td>
      <td colspan="2" class="def" valign="top" background="#path#index_r5_c3.jpg"><div align="left">
        <p align="center"><span class="style2"><cfoutput>  #SESSION.author#</cfoutput></span></p>
      </div></td>
      <td width="1" height="33"></td>
    </tr>
    <tr>
      <td colspan="3" background="#path#index_r6_c2.jpg"><div align="center"><span class="style4">Enter your ACCOUNT and PASSWORD below: </span></div></td>
      <td width="1" height="41"></td>
    </tr>
    <tr>
      <td colspan="3" background="#path#index_r7_c2.jpg">
	  
	  <div align="center"> <span class="style9 style6 style7">
	  
	  <cfif client.browser eq "Explorer" or client.browser eq "Firefox">
			  
	      <strong>ACCOUNT:</strong></span>
          <label>
             <cfinput name="account" class="regular" style="text-align: center;" type="text" value="#SESSION.acc#" size="20"  maxlength="20" required="yes" message="Please enter your account">
          </label>
		   
          <span class="style9 style6 style7"><strong>PASSWORD:</strong></span>
          <label>          
		  <input type="password" name="password" size="20" maxlength="20" class="regular" style="text-align: center;">  		
          </label>

          <label>
          <input class="button10s" type="submit" name="Submit" value="Login">
          </label>
		  
	 <cfelse>	
	 
	 		The backoffice ERP modules are not supported under Safari/Google. We recommend using Internet Explorer 7 or 8
		  
	 </cfif>	
	 	  
	</div>
	</td>
      <td width="1" height="45"></td>
    </tr>
    <tr>
      <td colspan="5" align="center" background="#path#index_r8_c1.jpg">
	   </td>
      <td width="1" height="56">
	  </td>
    </tr>
	<!---
	<tr>
      <td colspan="6" align="right">
	  <img src="#SESSION.root#/Images/cfmx-powered.png" alt="Powered by Adobe CFMX 7" width="80" height="15" border="0">
	   </td>
     </tr>
	 --->
  </table>
  
  
</cfoutput>
  
</div>
</body>
</html>
