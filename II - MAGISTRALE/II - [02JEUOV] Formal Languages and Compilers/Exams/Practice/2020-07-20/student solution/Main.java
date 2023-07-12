import java.io.*;
   
public class Main {
  static public void main(String argv[]) {    
    try {
      /* Scanner instantiation */
      Yylex l = new Yylex(new FileReader(argv[0]));
      /* Parser instantiation */
      parser p = new parser(l);
      /* Start the parser */
      Object result = p.parse();      
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}

