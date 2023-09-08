<%@ page import="com.study.connection.ConnectionTest" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<html>
<head>
    <title>JSP - 게시판</title>
</head>
<body>
<h1><%= "게시판 - 수정" %>
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
    <div style="margin-top: 1%; align-content: center; align-items: center; text-align: center">
        <form action="modify.jsp" style="margin-bottom: 5%; margin-top: 2%" method="post">
            <table style= "width:80%;">
                <tr>
                    <td style="color: black; font-weight: bolder;">
                        카테고리&nbsp;<%=rsPost.getString("category")%>
                    </td>
                </tr>
                <tr>
                    <td style="color: black; font-weight: bolder;">
                        등록일시&nbsp;<%=rsPost.getTimestamp("writedate")%>
                    </td>
                </tr>
                <tr>
                    <td style="color: black; font-weight: bolder;">
                        수정일시&nbsp;<%=rsPost.getTimestamp("modifydate")%>
                    </td>
                </tr>
                <tr>
                    <td style="color: black; font-weight: bolder;">
                        조회수&nbsp;<%=rsPost.getInt("hit")%>
                    </td>
                </tr>
                <tr>
                    <td style="color: black; font-weight: bolder;">
                        작성자&nbsp;<input type="text" name="writer" value="<%=rsPost.getString("writer")%>">
                    </td>
                </tr>
                <tr>
                    <td style="color: black; font-weight: bolder;">
                        비밀번호&nbsp;<input type="password" name="pw" value="<%=rsPost.getString("pw")%>">
                    </td>
                </tr>
                <tr>
                    <td style="color: black; font-weight: bolder;">
                        글제목&nbsp;<input type="text" name="title" value=" <%=rsPost.getString("title")%>">
                    </td>
                </tr>
                <tr>
                    <td style="color: black; font-weight: bolder;">
                        글내용<textarea rows="12" style="width:100%;" class="click" name="content" ><%=rsPost.getString("content")%></textarea>
                    </td>
                </tr>

                <%
                    }
                    } catch (Exception e){
                        e.printStackTrace();
                        System.out.println("errorModify : "+e.getMessage());
                    }
                %>
                <tr>
                    <td style="color: black; font-weight: bolder;">
                        파일첨부&nbsp;<input type="text" name="file"> <input type="file" value="파일 찾기"><br>
                        <input type="text" name="file2"> <input type="button" value="파일 찾기"><br>
                        <input type="text" name="file3"> <input type="button" value="파일 찾기"><br>
                    </td>
                </tr>

                <tr style="margin-bottom: 5%">
                    <!-- 글 수정 메뉴 -->
                    <td colspan="2" align="center" style="margin-bottom: 5%">
                        <input type="button" class="btn btn-primary" value="취소" onclick="history.back()">
                        <input type="hidden" name="boardnum" value="<%=boardnum %>">
                        <input type="submit" class="btn btn-primary" value="저장">
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <%
        if("POST".equalsIgnoreCase(request.getMethod())){


            String writer = request.getParameter("writer");
            String pw = request.getParameter("pw");
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            try{
                ConnectionTest t = new ConnectionTest();
                Connection conn = t.getConnection();

                PreparedStatement pst = conn.prepareStatement("UPDATE boardlist SET writer=?, pw=?, title=?, content=?, modifydate=NOW() WHERE boardnum=?");

                pst.setString(1, writer);
                pst.setString(2, pw);
                pst.setString(3, title);
                pst.setString(4, content);
                pst.setInt(5, boardnum);

                int result = pst.executeUpdate();

                if(result >0){
                    out.print("<script>alert('게시물이 수정되었습니다.');location.href='index.jsp';</script>");
                    return;
                } else {
                    out.print("<script>alert('게시물 수정이 실패했습니다.');history.back();</script>");
                }

                System.out.println("writer: "+writer);
            } catch (Exception e){
                e.printStackTrace();
                System.out.println("errorModifyUpdate" + e.getMessage());
            }
        }

    %>
</body>
</html>
