﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TerminationReportSummaryView.ascx.cs"
    Inherits="PraticeManagement.Controls.Reports.HumanCapital.TerminationReportSummaryView" %>
<%@ Register Src="~/Controls/FilteredCheckBoxList.ascx" TagName="FilteredCheckBoxList"
    TagPrefix="uc" %>
<table class="WholeWidthWithHeight">
    <tr>
        <td colspan="4" class="Width95Percent"></td>
        <td class=" Width5Percent padRight5">
            <table class="WholeWidth">
                <tr>
                    <td>Export:
                    </td>
                    <td>
                        <asp:Button ID="btnExportToExcel" runat="server" Text="Excel" OnClick="btnExportToExcel_OnClick"
                            UseSubmitBehavior="false" ToolTip="Export To Excel" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<asp:Panel ID="pnlDivision" Style="display: none;" runat="server">
    <uc:FilteredCheckBoxList ID="cblDivision" runat="server" />
</asp:Panel>
<asp:Panel ID="pnlFilterTitle" Style="display: none;" runat="server">
    <uc:FilteredCheckBoxList ID="cblTitles" runat="server" />
</asp:Panel>
<asp:Panel ID="pnlFilterPayType" Style="display: none;" runat="server">
    <uc:FilteredCheckBoxList ID="cblPayTypes" runat="server" />
</asp:Panel>
<asp:Panel ID="pnlFilterHireDate" Style="display: none;" runat="server">
    <uc:FilteredCheckBoxList ID="cblHireDate" runat="server" />
</asp:Panel>
<asp:Panel ID="pnlFilterTerminationDate" Style="display: none;" runat="server">
    <uc:FilteredCheckBoxList ID="cblTerminationDate" runat="server" />
</asp:Panel>
<asp:Panel ID="pnlFilterTerminationReason" Style="display: none;" runat="server">
    <uc:FilteredCheckBoxList ID="cblTerminationReason" runat="server" />
</asp:Panel>
<asp:Panel ID="pnlFilterPersonStatusType" Style="display: none;" runat="server">
    <uc:FilteredCheckBoxList ID="cblPersonStatusType" runat="server" />
</asp:Panel>
<asp:Panel ID="pnlFilterRecruiter" Style="display: none;" runat="server">
    <uc:FilteredCheckBoxList ID="cblRecruiter" runat="server" />
</asp:Panel>
<asp:Button ID="btnFilterOK" runat="server" OnClick="btnFilterOK_OnClick" Style="display: none;" />
<asp:Repeater ID="repResource" runat="server" OnItemDataBound="repResource_ItemDataBound">
    <HeaderTemplate>
        <div class="minheight250Px">
            <table id="tblTerminationSummaryReport" class="tablesorter TerminationReport WholeWidth zebra">
                <thead>
                    <tr class="TimeperiodSummaryReportTr">
                        <th class="ResourceColum">Resource
                            <img alt="Filter" src="../../../Images/divisions_16x16.png" title="Division" runat="server"
                                id="imgDivisionFilter" />
                            <AjaxControlToolkit:PopupControlExtender ID="pceDivision" runat="server" TargetControlID="imgDivisionFilter"
                                BehaviorID="pceDivision" PopupControlID="pnlDivision" Position="Bottom">
                            </AjaxControlToolkit:PopupControlExtender>
                        </th>
                        <th>Title
                            <img alt="Filter" title="Title" src="../../../Images/search_filter.png" class="FilterImg"
                                runat="server" id="imgTitleFilter" />
                            <AjaxControlToolkit:PopupControlExtender ID="pceTitleFilter" runat="server" TargetControlID="imgTitleFilter"
                                BehaviorID="pceTitleFilter" PopupControlID="pnlFilterTitle" Position="Bottom">
                            </AjaxControlToolkit:PopupControlExtender>
                        </th>
                        <th class="Width110PxImp">Pay Type
                            <img alt="Filter" title="Pay Type" src="../../../Images/search_filter.png" class="FilterImg"
                                runat="server" id="imgPayTypeFilter" />
                            <AjaxControlToolkit:PopupControlExtender ID="pcePayTypeFilter" runat="server" TargetControlID="imgPayTypeFilter"
                                BehaviorID="pcePayTypeFilter" PopupControlID="pnlFilterPayType" Position="Bottom">
                            </AjaxControlToolkit:PopupControlExtender>
                        </th>
                        <th>Status
                            <img alt="Filter" src="../../../Images/search_filter.png" runat="server" title="Person Status"
                                class="FilterImg" id="imgPersonStatusTypeFilter" />
                            <AjaxControlToolkit:PopupControlExtender ID="pcePersonStatusTypeFilter" runat="server"
                                TargetControlID="imgPersonStatusTypeFilter" BehaviorID="pcePersonStatusTypeFilter"
                                PopupControlID="pnlFilterPersonStatusType" Position="Bottom">
                            </AjaxControlToolkit:PopupControlExtender>
                        </th>
                        <th>Recruiter
                            <img alt="Filter" src="../../../Images/search_filter.png" runat="server" title="Recruiter"
                                class="FilterImg" id="imgRecruiterFilter" />
                            <AjaxControlToolkit:PopupControlExtender ID="pceRecruiterFilter" runat="server" TargetControlID="imgRecruiterFilter"
                                BehaviorID="pceRecruiterFilter" PopupControlID="pnlFilterRecruiter" Position="Bottom">
                            </AjaxControlToolkit:PopupControlExtender>
                        </th>
                        <th>Right to Present Start Date
                        </th>
                        <th>Hire Date
                            <img alt="Filter" src="../../../Images/search_filter.png" title="Hire Date" runat="server"
                                class="FilterImg" id="imgHiredateFilter" />
                            <AjaxControlToolkit:PopupControlExtender ID="pceHiredateFilter" runat="server" TargetControlID="imgHiredateFilter"
                                BehaviorID="pceHiredateFilter" PopupControlID="pnlFilterHireDate" Position="Bottom">
                            </AjaxControlToolkit:PopupControlExtender>
                        </th>
                        <th>Right to Present End Date
                        </th>
                        <th class="Width120PxImp">Termination Date
                            <img alt="Filter" src="../../../Images/search_filter.png" title="Terminaiton Date"
                                class="FilterImg" runat="server" id="imgTerminationdateFilter" />
                            <AjaxControlToolkit:PopupControlExtender ID="pceTerminationdateFilter" runat="server"
                                TargetControlID="imgTerminationdateFilter" BehaviorID="pceTerminationdateFilter"
                                PopupControlID="pnlFilterTerminationDate" Position="Bottom">
                            </AjaxControlToolkit:PopupControlExtender>
                        </th>
                        <th class="Width160PxImp">
                            <asp:Label runat="server" Style="width: 20px; height: 16px; padding-bottom: 3px;"
                                ID="imgTerminationReasonFilterHidden"> &nbsp;</asp:Label>
                            Termination Reason
                            <img alt="Filter" src="../../../Images/search_filter.png" runat="server" title="Termination Reason"
                                class="FilterImg" id="imgTerminationReasonFilter" />
                            <AjaxControlToolkit:PopupControlExtender ID="pceTermiantionReasonFilter" runat="server"
                                TargetControlID="imgTerminationReasonFilterHidden" BehaviorID="pceTermiantionReasonFilter"
                                PopupControlID="pnlFilterTerminationReason" Position="Bottom">
                            </AjaxControlToolkit:PopupControlExtender>
                        </th>
                    </tr>
                </thead>
                <tbody>
    </HeaderTemplate>
    <ItemTemplate>
        <tr class="ReportItemTemplate">
            <td style="text-align: left; padding-left: 2px;">
                <%# Eval("HtmlEncodedName")%>
            </td>
            <td>
                <%# Eval("Title.HtmlEncodedTitleName")%>
            </td>
            <td>
                <%# Eval("CurrentPay.TimescaleName")%>
            </td>
            <td>
                <%# Eval("Status.Name")%>
            </td>
            <td>
                <%# Eval("RecruiterLastFirstName")%>
            </td>
            <td>
                <%# GetDateFormat((DateTime?)Eval("RighttoPresentStartDate"))%>
            </td>
            <td>
                <%# GetDateFormat((DateTime)Eval("HireDate"))%>
            </td>
            <td>
                <%# GetDateFormat((DateTime?)Eval("RighttoPresentEndDate"))%>
            </td>
            <td>
                <%# GetDateFormat((DateTime?)Eval("TerminationDate"))%>
            </td>
            <td>
                <%# Eval("TerminationReason")%>
            </td>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
        </tbody></table></div>
    </FooterTemplate>
</asp:Repeater>
<div id="divEmptyMessage" runat="server">
    No people were terminated in the time range selected and/or that match the selected
    filters.
</div>

