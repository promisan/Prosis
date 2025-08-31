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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfoutput>
<cfset root = "#SESSION.root#">

<script>

var root = "#root#";
var id2 = "";
var id3 = "";

// function userlocate(formname, id ,id1, id2, id3) {

//	if (formname == "Webdialog") {
//		 ret = window.showxxxxModalDialog("<cfoutput>#SESSION.root#</cfoutput>/System/Access/Lookup/UserSearch.cfm?Form=" + formname + "&id=" + id + "&id1=" + id1 + "&id2=" + id2 + "&id3=" + id3 +"&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:740px; dialogWidth:700px; help:no; scroll:yes; center:yes; resizable:yes");
//		 if (ret) {	
//		    val = ret.split(";") 
//			document.getElementById(id).value = val[0]
//		    document.getElementById(id1).value = val[1]
//			document.getElementById(id2).value = val[2]
//			document.getElementById(id3).value = val[3]
//			     	
//	    }
//	 } else {	
//	    window.open(root + "/System/Access/Lookup/UserSearch.cfm?form=" + formname + "&id=" + id + "&id1=" + id1 + "&id2=" + id2 + "&id3=" + id3, "_blank", "width=740, height=700, status=yes, toolbar=no, scrollbars=no, resizable=yes");
//	 }

//	}

function selectuser(form, id , name, last, first) {
    window.open(root + "/System/Access/Lookup/DialogSearch.cfm?formName=" + form + "&flduserid=" + id + "&fldname=" + name + "&fldlastname=" + last + "&fldfirstname=" + first, "_blank", "width=700, height=500, status=yes, toolbar=yes, scrollbars=yes, resizable=no");
}

function SearchPerson(formname, fieldname)
{
	window.open(root + "/DWarehouse/Search/IndexSearch.cfm?FormName=" + formname + "&FieldName=" + fieldname, "SearchPerson", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
}

function selectvendor(FormName, fldvendor, fldvendorname) {
	window.open(root + "/Procurement/Vendor/VendorSearch.cfm?FormName=" + FormName + "&fldvendor= " + fldvendor + "&fldvendorname= " + fldvendorname, "IndexWindow", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
}

function selectitem(FormName, flditem, flditemname, fldacc, fldaccdes, fldacctpe) {
	window.open(root + "/Warehouse/Item/ItemSearchAccount.cfm?FormName=" + FormName + "&flditem= " + flditem + "&flditemname= " + flditemname + "&fldacc= " + fldacc + "&fldaccdes= " + fldaccdes + "&fldacctpe= " + fldacctpe, "IndexWindow", "width=700, height=600, toolbar=no, scrollbars=yes, resizable=yes");
}

function selectaccount(hform, acc, des, tpe) {
  	window.open(root + "/Gledger/Ledger/Inquiry/AccountSelect.cfm?ID=" + hform + "&ID1=" + acc + "&ID2=" + des + "&ID3=" + tpe, "AccountSelect", "left=100, top=100, width=500, height=650, toolbar=no, status=yes, scrollbars=yes, resizable=no");
}

function selectbank(hform, bnk, acc, cur) {
  	window.open(root + "/Gledger/Reference/Bank/BankSelect.cfm?ID=" + hform + "&ID1=" + bnk + "&ID2=" + acc +"&ID9=" + cur, "BankSelect", "left=100, top=100, width=400, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function ShowUser(Account) {
    w = #CLIENT.width# - 60;
    h = #CLIENT.height# - 130;
	window.open(root + "/System/Access/User/UserDetail.cfm?ID=" + Account + "&ID1=" + h + "&ID2=" + w, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=yes, scrollbars=no, resizable=yes");
}
</script>
</cfoutput>
