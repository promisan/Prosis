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

<cfset root = SESSION.root>

<script>
	
	var root = "#root#";
	var id2 = "";
	var id3 = "";	
			
	function userlocateN(formname,id,id1,id2,id3,id4) {
		
		wid = document.body.clientWidth-80
		if (wid > 900) {
		  wid = 900
		}
		ProsisUI.createWindow('userdialog', 'Users', '',{x:100,y:100,height:document.body.clientHeight-90,width:wid,modal:true,center:true})    
		ptoken.navigate(root + '/System/Access/Lookup/UserSearch.cfm?Form=' + formname + '&id=' + id + '&id1=' + id1 + '&id2=' + id2 + '&id3=' + id3 + '&id4=' + id4,'userdialog') 	
	
	}
	
	function memberlocate(form,id ,id1, id2, id3,group) {
	    ptoken.open(root + "/System/Access/Lookup/MemberResult.cfm?form=" + form + "&id=" + id + "&id1=" + id1 + "&id2=" + id2 + "&id3=" + id3 + "&group=" + group, "_blank", "width=740, height=700, status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}
	
	function selectuser(form, id , name, last, first) {
	    ptoken.open(root + "/System/Access/Lookup/DialogSearch.cfm?formName=" + form + "&flduserid=" + id + "&fldname=" + name + "&fldlastname=" + last + "&fldfirstname=" + first, "_blank", "width=700, height=500, status=yes, toolbar=yes, scrollbars=yes, resizable=no");
	}
	
	function SearchPerson(formname, fieldname) {
		ptoken.open(root + "/DWarehouse/Search/IndexSearch.cfm?FormName=" + formname + "&FieldName=" + fieldname, "SearchPerson", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
	}
	
	function ShowUser(Account) {
	    w = #CLIENT.width# - 60;
	    h = #CLIENT.height# - 100;
		ptoken.open(root + "/System/Access/User/UserDetail.cfm?ID=" + Account + "&ID1=" + h + "&ID2=" + w, "_blank");
	}
	
	function ShowUserRole(Account) {
	    w = #CLIENT.width# - 150;
	    h = #CLIENT.height# - 130;
		ptoken.open(root + "/System/Access/User/UserAccessListing.cfm?ID=" + Account + "&ID1=" + h + "&ID2=" + w, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}
	
	</script>

</cfoutput>