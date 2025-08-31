<!--
    Copyright © 2025 Promisan B.V.

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

	<table width="100%" align="center" cellpadding="0" cellspacing="0">
	
	<tr>
	<td>
	
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
		
		<tr><td class="title"><b>	What you need to know before requesting an account <hr></td></tr>
		
		<tr><td class="content">
		    

		
			A #SESSION.welcome# logon account allows you to access modules that are or will be opened for you to access. 
			In order for you to request a logon account you need to submit you first and lastname along with a valid eMail address.
			<br><br>
			Your request will be validated against the submitted e-Mail address which needs to be unique. 
			You might already have an assigned account and we will inform you immediately once we have matched your request. 
			Once your request is successfully submitted, you will be informed by designated officials about your account and granted access.
			<br><br>
			Your #SESSION.welcome# support group. <br><br>Thank you.
			<br><br>
			

		
		</td>
		
	   </tr>
	   
	   <tr><td class="linedotted"></td></tr>
		
	   <tr><td align="center" style="padding:4px">
	   <cf_tableround mode="solidborder" color="silver" padding="5px" totalwidth="80%" onmouseover="this.bgColor='0080C0'" onmouseout="this.bgColor='silver'">
			<img src="#SESSION.root#/images/finger.gif" alt="" border="0" align="absmiddle">	
			<a href="javascript:accountRequest('#url.id#');"><font size="2" face="Verdana" color="0080C0"><b><u>Click here</u></b></a></font>&nbsp;&nbsp;<font size="2" color="black"face="Verdana" >to request your User Logon account.</font>
	   </cf_tableround>
		   </td>
	    </tr>
		
		<tr><td class="linedotted"></td></tr>
		
		</table>
	
	</td>
	</tr>
	
	</table>

</cfoutput>