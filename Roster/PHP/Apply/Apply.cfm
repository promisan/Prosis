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
<cf_tabletop size="100%">

<table width="100%" border="0" bordercolor="d4d4d4">

<cfform action="#SESSION.root#/Roster/PHP/Apply/ApplySubmit.cfm?id=#URL.ID#" method="post">

<tr><td height="24">&nbsp;
<b><font color="0080FF">Questions a candidate needs to answer (allows for filtering)</td></tr>
<tr><td colspan="1" bgcolor="silver"></td></tr>
<tr><td height="20">
	<cfinclude template="Question.cfm">
</td></tr>

<tr><td height="24">&nbsp;
	<b><font color="0080FF">Describe how your experience, qualifications and competencies match the position for which you are applying</td></tr>
<tr><td colspan="1" bgcolor="silver"></td></tr>	

<tr><td height="20">	

<cf_textarea name="ApplicationMemo"                 
           toolbaronfocus = "No"
           bindonload     = "No" 
	       height         = "#client.height#-350"				 			 				          
           richtext       = "Yes"             
           toolbar        = "Basic"
           skin           = "Silver"/>
</cf_textarea>					

</td></tr>

<tr><td height="24">&nbsp;<b><font color="0080FF">Disclaimer Text</td></tr>
<tr><td colspan="1" bgcolor="silver"></td></tr>
<!--- questions--->
<tr><td height="20">
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td>
	<table cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td>
	The generic vacancy announcements are used to generate candidates for the roster. While preferences will be registered and taken into account, qualified individuals willing to serve in several/all locations will, of course, have a greater possibility of serving. 
	</td></tr><tr><td>
	Your application will be screened and evaluated against the requirements set out in the vacancy announcement. If you meet the requirements of the vacancy announcements your application will be included in a roster system that will be submitted for all vacancies in your occupational group and grade for field missions of your choice. Your application will remain valid in the roster for a period of 12 months. Should you wish to remain in the roster after the initial 12 months, please update and resubmit your PHP. 
	</td></tr><tr><td>
	You can also apply for a post-specific vacancy announcement. You will be evaluated against the requirements as specified in the particular vacancy and your name may be put forward for that specific announcement only. Your application will not be placed in the roster unless you apply to a generic (multiple duty stations M/S) vacancy announcement.
	</td></tr><tr><td>
	In view of the high volume of applications received, only those applicants who are included in the roster will be notified.
	</td></tr><tr><td>
	E-mail: , 
	</td></tr>
	</table>
</td></tr>
</table>
</td></tr>
<tr><td colspan="1" bgcolor="silver"></td></tr>

<tr><td align="center" height="30">
<input class="button10g" onclick="history.back()" type="button" name="Cancel" value="Cancel">
<input class="button10g" type="submit" name="Apply" value="Apply Now">
</td></tr>
</cfform>
</table>

<cf_tableBottom size="100%">
