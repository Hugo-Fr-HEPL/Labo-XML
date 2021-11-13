import java.io.File;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import javax.xml.parsers.ParserConfigurationException;


public class SimplestDomParser {
    static boolean XSD = true;

    public static void main(String[] args) {
        DocumentBuilderFactory factory= DocumentBuilderFactory.newInstance();
        try {
            factory.setValidating(true);
            DocumentBuilder builder= factory.newDocumentBuilder();

            File fileXML= new File(GetNomFichier("movies.xml"));

            Document xml= builder.parse(fileXML);
            Element root= xml.getDocumentElement();
            System.out.println(root.getNodeName());
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