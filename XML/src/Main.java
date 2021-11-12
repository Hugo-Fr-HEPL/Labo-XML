import java.io.*;
import java.util.*;



public class Main {
    static BufferedReader br = null;
    static BufferedWriter bf1 = null;
    static BufferedWriter bf2 = null;

    public static void main(String[] args) {
        try {
            bf1 = new BufferedWriter(new FileWriter(GetNomFichier("films.dtd")));
            bf2 = new BufferedWriter(new FileWriter(GetNomFichier("films.xml")));
            br = new BufferedReader(new FileReader(GetNomFichier("movies.txt")));
        } catch (IOException e) {
            e.printStackTrace();
        }

        WriteDTD();

        ListIterator<String> lFilms = Divide("\n", readAll(br)).listIterator();

        Vector<String> infos;
        String film1;
        while(lFilms.hasNext()) {
            WriteFichier("<film>\n", 2);
            film1 = lFilms.next().toString();
            infos = new Vector<String>();
            infos = Divide("‣", film1);

            String[] names = {"id", "title", "originalTitle", "releaseDate", "status", "voteAverage", "voteCount", "runtime", "certification", "posterPath", "budget", "tagline"};

            for(int i = 0; i < infos.size(); i++) {
                if(i < 12)
                    WriteXML(names[i], infos.get(i), 1);
                else {
                    switch (i) {
                        case 12:
                            String[] genres = {"idg", "nameg"};
                            WriteXMLPlus("genre", infos.get(i), genres);
                            break;
                        case 13:
                            String[] directors = {"idd", "named"};
                            WriteXMLPlus("director", infos.get(i), directors);
                            break;
                        case 14:
                            String[] actors = {"ida", "namea", "charactera"};
                            WriteXMLPlus("actor", infos.get(i), actors);
                            break;
                    }
                }
            }
            WriteFichier("</film>\n", 2);
        }

        try {
            bf2.write("</films>");
            bf1.close();
            bf2.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void WriteDTD() {
        WriteFichier("<!DOCTYPE films SYSTEM \"films.dtd\">\n", 2);
        WriteFichier("<?xml-stylesheet href =\"./films.xslt\" type=\"text/xsl\" ?>\n", 2);
        WriteFichier("<films>\n", 2);

        WriteFichier("<!ELEMENT films (film*)>\n", 1);
        WriteFichier("<!ELEMENT film (id,title,originalTitle,releaseDate,status,voteAverage,voteCount,runtime,certification,posterPath,budget,tagline,genres,directors,actors)>\n", 1);
        WriteFichier("<!ELEMENT id (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT title (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT originalTitle (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT releaseDate (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT status (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT voteAverage (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT voteCount (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT runtime (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT certification (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT posterPath (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT budget (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT tagline (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT genres ((genre)*)>\n", 1);
            WriteFichier("<!ELEMENT genre ((idg, nameg)*)>\n", 1);
            WriteFichier("<!ELEMENT idg (#PCDATA)>\n", 1);
            WriteFichier("<!ELEMENT nameg (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT directors ((director)*)>\n", 1);
            WriteFichier("<!ELEMENT director ((idd, named)*)>\n", 1);
            WriteFichier("<!ELEMENT idd (#PCDATA)>\n", 1);
            WriteFichier("<!ELEMENT named (#PCDATA)>\n", 1);
        WriteFichier("<!ELEMENT actors ((actor)*)>\n", 1);
            WriteFichier("<!ELEMENT actor ((ida, namea, charactera)*)>\n", 1);
            WriteFichier("<!ELEMENT ida (#PCDATA)>\n", 1);
            WriteFichier("<!ELEMENT namea (#PCDATA)>\n", 1);
            WriteFichier("<!ELEMENT charactera (#PCDATA)>\n", 1);
    }

    public static String readAll(BufferedReader reader) {
        StringBuffer buffer = new StringBuffer();

        while (true) {
            try {
                String line = reader.readLine();

                if(line == null) break;
                buffer.append(line + "\n");
            }
            catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
        return buffer.toString();
    }

    public static String GetNomFichier(String nomf) {
        return System.getProperty("user.dir") + System.getProperty("file.separator") + "XML" + System.getProperty("file.separator") + "Fichiers" + System.getProperty("file.separator") + nomf;
    }

    public static void WriteFichier(String chaine, int i) {
        try {
            if(i == 1)
                bf1.write(chaine);
            else
                bf2.write(chaine);
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void WriteXML(String balise, String chaine, int i) {
        chaine = chaine.replaceAll("&", "&amp;");

        try {
            for(int j = 0; j < i; j++)
                bf2.write("\t");

            bf2.write("<" + balise + ">");
            bf2.write(chaine);
            bf2.write("</" + balise + ">\n");
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void WriteXMLPlus(String balise, String chaine, String[] sousBalise) {
        WriteFichier("\t<"+ balise +"s>\n", 2);

        ListIterator<String> lContents = Divide("‖", chaine).listIterator();
        while(lContents.hasNext()) {
            WriteFichier("\t\t<"+ balise +">\n", 2);

            String infog = lContents.next().toString();
            if(infog.equals("") == false) {
                Vector<String> infosg = Divide("․", infog);
                for(int i = 0; i < sousBalise.length; i++)
                    WriteXML(sousBalise[i], infosg.get(i), 3);
            } else
                for(int i = 0; i < sousBalise.length; i++)
                    WriteFichier("\t\t\t<"+ sousBalise[i] +"></"+ sousBalise[i] +">\n", 2);

            WriteFichier("\t\t</"+ balise +">\n", 2);
        }
        WriteFichier("\t</"+ balise +"s>\n", 2);
    }

    public static Vector<String> Divide(String sep, String chaine) {
        Vector<String> infos = new Vector<String>();

        for(int i = 0, j = 0; i != -1; j = i+1) {
            i = chaine.indexOf(sep, j);
            infos.add(i != -1 ? chaine.substring(j, i) : chaine.substring(j));
        }
        return infos;
    }
}
