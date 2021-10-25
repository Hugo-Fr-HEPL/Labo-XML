import java.io.IOException;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.SAXException;

public class SimplestSaxParser {

    public static void main(String[] args) {
        try {

            SAXParserFactory factory = SAXParserFactory.newInstance();

            factory.setValidating(true);
            factory.setNamespaceAware(true);

            SAXParser sp = factory.newSAXParser();
            sp.parse("C:\\Users\\dries\\IdeaProjects\\XML\\Fichiers\\films.xml", new HandlerSAX());

        }
        catch (ParserConfigurationException pce) {
            System.out.println("ParserConfigurationException : " + pce.getMessage());
        }
        catch (IOException io) {
            System.out.println("IOException : " + io.getMessage());
        }
        catch (SAXException se){
            System.out.println("SaxEXception : " + se.getMessage());
        }
    }

}