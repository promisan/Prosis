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

<body onload="set_focus()">

<!---

<style type="text/css">
	
	/*Sample CSS used for the Virtual Pagination Demos. Modify/ remove as desired*/
	
	.paginationstyle{ /*Style for demo pagination divs*/
	width: 250px;
	text-align: center;
	padding: 2px 0;
	margin: 10px 0;
	}
	
	.paginationstyle select{ /*Style for demo pagination divs' select menu*/
	border: 1px solid #666666;
	margin: 0 15px;
	}
	
	.paginationstyle a{ /*Pagination links style*/
	padding: 0 5px;
	text-decoration: none;
	border: 1px solid #DDDDDD;
	color: navy;
	background-color: white;
	}
	
	.paginationstyle a:hover, .paginationstyle a.selected{
	color: #FFFFFF;
	background-color: #0063e3;
	}	
	
	.paginationstyle a.disabled, .paginationstyle a.disabled:hover{ /*Style for "disabled" previous or next link*/
	background-color: white;
	cursor: default;
	color: #929292;
	border-color: transparent;
	}
	
	.paginationstyle a.imglinks{ /*Pagination Image links style (class="imglinks") */
	border: 0;
	padding: 0;
	}
	
	.paginationstyle a.imglinks img{
	vertical-align: bottom;
	border: 0;
	}
	
	.paginationstyle a.imglinks a:hover{
	background: none;
	}
	
	.paginationstyle .flatview a:hover, .paginationstyle .flatview a.selected{ /*Pagination div "flatview" links style*/
	color: #FFFFFF;
	border:solid 1px #DDDDDD;
	
	}
	

	table {
		font: 11px/24px Verdana, Arial, Helvetica, sans-serif;
	
	}

	th {
		padding: 0 0.5em;
	}
	td+td {
		border-left: 1px solid #CCC;
	}	
	
</style>

--->

<!--- used ?

<script type="text/javascript" src="virtualpaginate.js">

/***********************************************
* Virtual Pagination script- � Dynamic Drive DHTML code library (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
***********************************************/

</script>

--->
 
<cfajaximport tags="cfform,cfdiv">

<cf_searchScript>
<cf_filelibraryscript>
<cf_dialogstaffing>

<cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.idmenu#"		
	Label           = "Yes">

<cf_tl id="Prosis Search Engine" var="1">

<cf_screentop html="yes" title="#lt_text#" label="#lt_text#" bannerheight="60" layout="webdialog" banner="blue">	

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td id="contentbox" height="100%">
						   
		<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">  
				
		<tr><td id="search_Solr" class="hide">
		
			<table width="90%" border="0" bordercolor="e4e4e4" cellspacing="0" cellpadding="0" align="center" class="formpadding">
								
				<tr><td>Usage</td><td>Example</td></tr>
				<tr><td colspan="2" height="1" bgcolor="d4d4d4"></td></tr>		
				<tr><td>Exact word</td>
				     <td><i>France</td></tr>
				<tr><td colspan="2" height="1" bgcolor="d4d4d4"></td></tr>		 
				<tr><td>At least one word</td>
				     <td><i>+France Egypt Sudan</td></tr>		
				<tr><td colspan="2" height="1" bgcolor="d4d4d4"></td></tr>		 
				<tr><td>ALL of the words</td>
				
				     <td><i>+France +Egypt</td></tr>	
				<tr><td colspan="2" height="1" bgcolor="d4d4d4"></td></tr>		 
				<tr><td>Search for one word, but not the other</td>
				    <td><i>+France -Egypt</td></tr>
				<tr><td colspan="2" height="1" bgcolor="d4d4d4"></td></tr>		
				<tr><td>Fuzzy search:</td>
				    <td><i>Franc<b>~</b></td></tr>
				<tr><td colspan="2" height="1" bgcolor="d4d4d4"></td></tr>		
				<tr><td>Wildcard search</td>
				     <td><i>Fr?nce</td></tr>		
				<tr><td colspan="2" height="1" bgcolor="d4d4d4"></td></tr>		 
				<tr><td>This example searches for 'france', 'fraance', 'fraence'</td>
					<td><i>Fr*nce</td></tr>	
				<tr><td colspan="2" height="1" bgcolor="d4d4d4"></td></tr>		
				<tr><td colspan="2"><font color="808080">Note: You cannot use a * or question mark (?) symbol as the first character of a search</td></tr></tr>
				<tr><td colspan="2" align="right">
				<a href="http://help.adobe.com/en_US/ColdFusion/9.0/Developing/WS82937B1B-240F-4850-B376-5FD9F911E5E5.html" target="_blank"><font color="0080C0">[more]</a>
				<a href="javascript:help('Solr',0)"><font color="0080C0">[close]</a></td></tr>
				<tr><td colspan="2" class="line"></td></tr>
			</table>

		</td></tr>

		<tr><td id="search_Verity" class="hide">
		
			<table width="90%" border="0" bordercolor="e4e4e4" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		    <tr>
			<td><b>Operator</b></td>
			<td width="3%"></td>
		    <td><b>Description</b></td>
			<td width="3%"></td>
		    <td><b>Example</b></td>
			</tr>
			<tr><td>STEM</td>
				<td></td>
			    <td>Expands the search to include the word that you enter and its variations. The STEM operator is automatically implied in any simple query.</td>
				<td></td>				
			    <td><i>&lt;STEM&gt;believe</i> retrieves matches such as &quot;believe,&quot; &quot;believing,&quot; and &quot;believer&quot;.</p></td>
		    </tr>
			<tr>
			<td>WILDCARD</td>
			<td></td>
		    <td>Matches wildcard characters included in search strings. Certain characters automatically indicate a wildcard specification, such as apostrophe (*) and question mark(?). </td>
			<td></td>			
		    <td><i>spam*</i> retrieves matches such as, spam, spammer, and spamming.</td>
		    </tr>
			
			<tr>
			<td>WORD</td>
			<td></td>
    		<td>Performs a basic word search, selecting documents that include one or more instances of the specific word that you enter. The WORD operator is automatically implied in any SIMPLE query.</td>
			<td></td>
		    <td><i>&lt;WORD&gt; logic</i> retrieves logic, but not variations such as logical and logician.</td>
			</tr>
			
			<tr>
		    <td>THESAURUS</td>
			<td></td>
		    <td>Expands the search to include the word that you enter and its synonyms. Collections do not have a thesaurus by default; to use this feature you must build one.</td>
			<td></td>
		    <td><i>&lt;THESAURUS&gt; altitude</i> retrieves documents containing synonyms of the word altitude, such as height or elevation.</td>
		    </tr>
			
		    <tr>
			<td>SOUNDEX</td>
			<td></td>
		    <td>Expands the search to include the word that you enter and one or more words that &quot;sound like,&quot; or whose letter pattern is similar to, the word specified. Collections do not have sound-alike indexes by default; to use this feature you must build sound-alike indexes.</td>
			<td></td>
		    <td><i>&lt;SOUNDEX&gt; sale</i> retrieves words such as sale, sell, seal, shell, soul, and scale. </td>
			</tr>
			
		    <tr>
			<td>TYPO/N</td>
			<td></td>
		    <td>Expands the search to include the word that you enter plus words that are similar to the query term. This operator performs &quot;approximate pattern matching&quot; to identify similar words. The optional N variable in the operator name expresses the maximum number of errors between the query term and a matched term, a value called the error distance. If N is not specified, the default error distance is 2.</td>
			<td></td>
		    <td><i>&lt;TYPO&gt; swept</i> retrieves kept.</td>
			</tr>
			
			<tr>
			<td colspan="5" align="right">
			<a href="http://help.adobe.com/en_US/ColdFusion/9.0/Developing/WS82937B1B-240F-4850-B376-5FD9F911E5E5.html" target="_blank"><font color="0080C0">[more]</a>
			<a href="javascript:help('Verity',0)"><font color="0080C0">[close]</a></td>
			</tr>
			
			<tr><td colspan="5" class="line"></td></tr>
							
			</table>

		</td></tr>		
		
							
		<tr>	
			<td height="20" colspan="1" align="center" id="searchbox">			
				<cfinclude template="SearchBasic.cfm">			
			</td>
		</tr>	
													
		<tr><td height="1" colspan="4" class="line"></td></tr>
		
		<tr>
			<td id="getcontent" colspan="4" valign="top" colspan="1" height="100%" width="100%"></td>						
		</tr>	
		
		</table>
		
</td></tr>
</table>
