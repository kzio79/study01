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
<div style="display: flex; justify-content: center; align-items: center; margin: 20%">
    <article style="text-align: center; border: 3px solid #dddddd; width: 40%">
        <form name="swarchpw" method="post">
            <table >
                <h3>비밀번호를 입력하세요</h3><br>
                <input type="password" name="pw" placeholder="비밀번호를 입력하세요" required="required">
                <input type="hidden" name="boardnum" value="<%=request.getParameter("boardnum")%>">
                <input type="submit" name="pwbtn" value="삭제">
            </table>
        </form>
    </article>
</div>
<%
    int boardnum = Integer.parseInt(request.getParameter("boardnum"));
    String pw = request.getParameter("pw");

    if(pw != null){
        try {
            ConnectionTest t = new ConnectionTest();
            Connection conn = t.getConnection();

            PreparedStatement checkpw = conn.prepareStatement("SELECT * FROM boardlist WHERE boardnum=? AND pw=?");
            checkpw.setInt(1, boardnum);
            checkpw.setString(2, pw);

            ResultSet pwrs = checkpw.executeQuery();

            if(pwrs.next()){
                PreparedStatement ps = conn.prepareStatement("DELETE FROM boardlist WHERE boardnum=? AND pw=?");

                ps.setInt(1, boardnum);
                ps.setString(2, pw);
                int result = ps.executeUpdate();
                if(result >0){
                    out.print("<script>alert('게시물이 삭제되었습니다.');location.href='index.jsp';</script>");
                } else {
                    out.print("<script>alert('게시물 삭제에 실패했습니다.');history.back();</script>");
                }
            } else {
                out.print("<script>alert('비밀번호가 틀립니다.');history.back();</script>");
            }

            checkpw.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

%>
</body>
</html>
