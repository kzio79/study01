<%@ page import="com.study.connection.ConnectionTest" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>JSP - 게시판</title>
</head>
<body>
<h1><%="게시판 - 보기"%>
</h1>
<br/>
<%
    request.setCharacterEncoding("UTF-8");
    int boardnum = Integer.parseInt(request.getParameter("boardnum"));

    ResultSet rsPost = null;
    try {
        ConnectionTest t = new ConnectionTest();
        Connection conn = t.getConnection();

        PreparedStatement pstPost = conn.prepareStatement("SELECT * FROM boardlist WHERE boardnum=?");
        pstPost.setInt(1, boardnum);

        rsPost = pstPost.executeQuery();
        if(rsPost.next()){

            %>
<div align="center" style="margin-top: 2%; width: 80%">

    <div style="display:flex; justify-content: space-between; margin-left: 10%">
        <td name="writer" style="color: black; font-weight: bolder; " aria-readonly="true">
            <%=rsPost.getString("writer")%>
        </td>

        <div>
            <td name="writedate" style="align-items:end; color: black; font-weight: bolder;" aria-readonly="true">
                등록일시&nbsp<%=rsPost.getTimestamp("writedate")%>
            </td>
            &nbsp&nbsp&nbsp&nbsp
            <td name="modifydate" style="color: black; font-weight: bolder;" aria-readonly="true">
                수정일시&nbsp
                <%
                    if(rsPost.getTimestamp("writedate").equals(rsPost.getTimestamp("modifydate"))){
                        out.print("-");
                    }else{
                        out.print(rsPost.getTimestamp("modifydate"));
                    }

                %>
            </td>
        </div>
    </div>

    <div style="display:flex; justify-content: space-between; margin-left: 10%">
        <td name="category" style="color: black; font-weight: bolder;" aria-readonly="true">
            [<%=rsPost.getString("category")%>]&nbsp<%=rsPost.getString("title")%>
        </td>
        <div>
            <td name="hit" style="color: black; font-weight: bolder;" aria-readonly="true">
                조회수&nbsp<%=rsPost.getInt("hit")%>
            </td>
        </div>
    </div>
</div>
<%
            PreparedStatement pshit = conn.prepareStatement("UPDATE boardlist SET hit=hit+1 WHERE boardnum=?");
            pshit.setInt(1, boardnum);
            pshit.executeUpdate();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<hr>
<div >
    <div align="center"   style="margin-top: 1%;">
        <form action="delete.jsp" name="regform" style="margin-bottom: 5%; margin-top: 2%" method="post">
            <table style= "width:80%;">
                <tr >
                    <td style="color: black; font-weight: bolder;">
                        <textarea rows="12" style="text-align: left; width: 80%;" class="click" name="content" id="content" readonly>
                        <%=rsPost.getString("content")%>
                        </textarea>
                    </td>
                </tr>
                <tr>
                    <td style="color: black; font-weight: bolder;">
                        <input type="text" name="file"> <input type="file" value="파일 찾기"><br>
                        <input type="text" name="file2"> <input type="button" value="파일 찾기"><br>
                        <input type="text" name="file3"> <input type="button" value="파일 찾기"><br>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center" style="margin-bottom: 5%">
                        <input type="button" class="btn btn-primary" value="목록" onclick="location.href='index.jsp'">
                        <input type="button" class="btn btn-primary" value="수정" onclick="location.href='modify.jsp?boardnum=<%=boardnum%>'">
                        <input type="hidden" name="boardnum" value="<%=boardnum%>">
                        <input type="submit" class="btn btn-primary" value="삭제">
                    </td>
                </tr>
            </table>
        </form>

        <div>
            <div align="center" style="margin: 2%;">
                <form id="replyfresh" action="content.jsp" method="post">
                    <input type="hidden" name="boardnum" value="<%=boardnum%>">
                    <table style="border: 1px solid #dddddd; width: 80%">
                        <tr>
                            <td style="border-bottom:none;" valign="middle"></td>
                            <td style="color: black; font-weight: bolder;" id="replylist">
                                <%
                                    String reply = request.getParameter("reply");

                                    if(reply != null && !reply.isEmpty()){
                                        try{
                                            ConnectionTest t = new ConnectionTest();
                                            Connection conn = t.getConnection();

                                            PreparedStatement ps = conn.prepareStatement(
                                                    "INSERT INTO replylist(boardnum,content) VALUES (?,?)"
                                            );

                                            ps.setInt(1, boardnum);
                                            ps.setString(2, reply);
                                            ps.executeUpdate();

                                        } catch (Exception e){
                                            e.printStackTrace();
                                        }
                                    }

                                    try {
                                        ConnectionTest t = new ConnectionTest();
                                        Connection conn = t.getConnection();

                                        PreparedStatement pstPost = conn.prepareStatement("SELECT * FROM replylist WHERE boardnum=? ORDER BY replydate DESC");
                                        pstPost.setInt(1, boardnum);

                                        ResultSet rstPost = pstPost.executeQuery();

                                        while(rstPost.next()){
                                            out.print(rstPost.getTimestamp("replydate") + "<br>" + rstPost.getString("content") + "<hr>");
                                        }

                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                %>
                            </td>
                        </tr>
                        <tr>
                            <td style="border-bottom:none;" valign="middle"></td>
                            <td style="color: black; font-weight: bolder;">
                                <textarea rows="2" style="width:100%;" name="reply" id="reply" placeholder="댓글을 입력해 주세요"></textarea>
                            </td>
                            <td><input type="submit" class="btn btn-primary pull" value="등록"></td>
                        </tr>
                    </table>
                </form>
            </div>
        </div>
</div>
</body>
</html>
