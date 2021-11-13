import java.io.File;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import javax.xml.parsers.ParserConfigurationException;


// XSD must be disabled in Main.java
public class SimplestDomParser {
    static int cptCertif = 0;

    public static void main(String[] args) {
        try {
            DocumentBuilderFactory factory= DocumentBuilderFactory.newInstance();

            factory.setValidating(true);
            factory.setIgnoringElementContentWhitespace(true);

            DocumentBuilder builder= factory.newDocumentBuilder();
            builder.setErrorHandler(new HandlerDOM());

            File fileXML= new File(GetNomFichier("movies.xml"));

            Document xml= builder.parse(fileXML);
            Element root= xml.getDocumentElement();

            NodeList certifs = root.getElementsByTagName("certification");
            for(int i = 0; i < certifs.getLength(); i++)
                if((certifs.item(i).getTextContent()).equals("PG-13") == true)
                    cptCertif++;

            String[][] classement = {{"", "0.0"}, {"", "0.0"}, {"", "0.0"}, {"", "0.0"}, {"", "0.0"},
                                    {"", "0.0"}, {"", "0.0"}, {"", "0.0"}, {"", "0.0"}, {"", "0.0"}};

            NodeList movies = root.getElementsByTagName("movie");
            for(int i = 0, j; i < movies.getLength(); i++) {
                NodeList tmp = movies.item(i).getChildNodes();
                for(j = 0; j < 10; j++)
                    if(Double.parseDouble(tmp.item(5).getTextContent()) < Double.parseDouble(classement[j][1]))
                        break;

                j--;
                if(0 < j) {
                    for(int k = 0; k < j-1; k++) {
                        classement[k][0] = classement[k+1][0];
                        classement[k][1] = classement[k+1][1];
                    }
                    classement[j][0] = tmp.item(2).getTextContent();
                    classement[j][1] = tmp.item(5).getTextContent();
                }
            }

            System.out.println("Nb de PG-13 : " + cptCertif);
            System.out.println("Classement : ");
            for(int i = 0; i < 10; i++)
                System.out.println(classement[i][0] + " - " + classement[i][1]);

            /*
            if(vote == true) {
                film.add(chaine);
                j =- 1;
                for(int i = 0; i < 10; i++) {
                    temp = (Vector<String>)classement.get(i);
                    note1 = Double.parseDouble((String)temp.get(1));
                    note2 = Double.parseDouble((String)film.get(1));
                    if (note1 < note2)
                        j = i;
                    else
                        break;
                }

                if(j != -1) {
                    int k = j;
                    temp1 = (Vector<String>)classement.get(k);
                    for(; k >= 0; k--) {
                        if(k-1 != -1) {
                            temp2 = (Vector<String>)classement.get(k-1);
                            classement.set(k-1, temp1);
                        }
                        temp1 = temp2;
                    }

                    classement.set(j, film);
                }
            }
            */
        }
        catch(SAXParseException e) {}
        catch(ParserConfigurationException e) { e.printStackTrace(); }
        catch(SAXException e) { e.printStackTrace(); }
        catch(IOException e) { e.printStackTrace(); } 
    }

    public static String GetNomFichier(String nomf) {
        return System.getProperty("user.dir") + System.getProperty("file.separator") + "XML" + System.getProperty("file.separator") + "Fichiers" + System.getProperty("file.separator") + nomf;
    }
}