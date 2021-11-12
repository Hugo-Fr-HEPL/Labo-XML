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
        }
        catch (IOException e) {
            e.printStackTrace();
        }

        WriteDTD();

        String films;
        films= readAll(br);

        int i, j = 0;
        String film;
        Vector<String> vec = new Vector<String>();

        while(true) {
            i = films.indexOf("\n", j);
            if(i == -1)
                break;

            film = films.substring(j, i);
            j = i + 1;
            vec.add(film);
        }
        ListIterator<String> litr = vec.listIterator();
        Vector<String> infos;
        String film1;
        while(litr.hasNext()) {
            WriteFichier("<film>\n", 2);
            film1 = litr.next().toString();
            infos = new Vector<String>();
            infos = Divide("‣", film1);

            for(int champ = 0; champ < infos.size(); champ++) {
                switch (champ) {
                    case 0: WriteXML("id", infos.get(champ), 1);
                        break;
                    case 1: WriteXML("title", infos.get(champ), 1);
                        break;
                    case 2: WriteXML("originalTitle", infos.get(champ), 1);
                        break;
                    case 3: WriteXML("releaseDate", infos.get(champ), 1);
                        break;
                    case 4: WriteXML("status", infos.get(champ), 1);
                        break;
                    case 5: WriteXML("voteAverage", infos.get(champ), 1);
                        break;
                    case 6: WriteXML("voteCount", infos.get(champ), 1);
                        break;
                    case 7: WriteXML("runtime", infos.get(champ), 1);
                        break;
                    case 8: WriteXML("certification", infos.get(champ), 1);
                        break;
                    case 9: WriteXML("posterPath", infos.get(champ), 1);
                        break;
                    case 10: WriteXML("budget", infos.get(champ), 1);
                        break;
                    case 11: WriteXML("tagline", infos.get(champ), 1);
                        break;
                    case 12:
                            WriteFichier("\t<genres>\n", 2);
                            Vector<String> genres = new Vector<String>();
                            genres = Divide("‖", infos.get(champ));

                            ListIterator<String> litr1 = genres.listIterator();
                            Vector<String> infosg;
                            String infog;
                            while(litr1.hasNext()) {
                                WriteFichier("\t\t<genre>\n", 2);
                                infog = litr1.next().toString();
                                infosg = new Vector<String>();
                                if(infog.equals("") == false) {
                                    infosg = Divide("․", infog);
                                    WriteXML("idg", infosg.get(0), 3);
                                    WriteXML("nameg", infosg.get(1), 3);
                                }
                                else {
                                    WriteFichier("\t\t\t<idg></idg>\n", 2);
                                    WriteFichier("\t\t\t<nameg></nameg>\n", 2);
                                }
                                WriteFichier("\t\t</genre>\n", 2);
                            }
                            WriteFichier("\t</genres>\n", 2);
                        break;
                    case 13:
                            WriteFichier("\t<directors>\n", 2);
                            Vector<String> directors = new Vector<String>();
                            directors = Divide("‖", infos.get(champ));

                            ListIterator<String> litr2 = directors.listIterator();
                            Vector<String> infosd;
                            String infod;
                            while(litr2.hasNext()) {
                                WriteFichier("\t\t<director>\n", 2);
                                infod = litr2.next().toString();
                                infosd = new Vector<String>();
                                if(infod.equals("") == false) {
                                    infosd = Divide("․", infod);
                                    WriteXML("idd", infosd.get(0), 3);
                                    WriteXML("named", infosd.get(1), 3);
                                }
                                else {
                                    WriteFichier("\t\t\t<idd></idd>\n", 2);
                                    WriteFichier("\t\t\t<named></named>\n", 2);
                                }
                                WriteFichier("\t\t</director>\n", 2);
                            }
                            WriteFichier("\t</directors>\n", 2);
                        break;
                    case 14:
                            WriteFichier("\t<actors>\n", 2);
                            Vector<String> actors = new Vector<String>();
                            actors = Divide("‖", infos.get(champ));

                            ListIterator<String> litr3 = actors.listIterator();
                            Vector<String> infosa;
                            String infoa;
                            while(litr3.hasNext()) {
                                WriteFichier("\t\t<actor>\n", 2);
                                infoa = litr3.next().toString();
                                infosa = new Vector<String>();

                                if(infoa.equals("") == false) {
                                    infosa = Divide("․", infoa);
                                    WriteXML("ida", infosa.get(0), 3);
                                    WriteXML("namea", infosa.get(1), 3);
                                    WriteXML("charactera", infosa.get(2), 3);
                                }
                                else {
                                    WriteFichier("\t\t\t<ida></ida>\n", 2);
                                    WriteFichier("\t\t\t<namea></namea>\n", 2);
                                    WriteFichier("\t\t\t<charactera></charactera>\n", 2);
                                }
                                WriteFichier("\t\t</actor>\n", 2);
                            }
                            WriteFichier("\t</actors>\n", 2);
                        break;
                }
            }
            WriteFichier("</film>\n", 2);
        }

        try {
            bf2.write("</films>");
            bf1.close();
            bf2.close();
        }
        catch (IOException e) {
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

                if(line == null)
                    break;
                else
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

    public static Vector<String> Divide(String sep, String chaine) {
        Vector<String> infos = new Vector<String>();

        for(int i = 0, j = 0; i != -1; j = i+1) {
            i = chaine.indexOf(sep, j);
            infos.add(i != -1 ? chaine.substring(j, i) : chaine.substring(j));
            /*
            if(i != -1)
                infos.add(chaine.substring(j, i));
            else
                infos.add(chaine.substring(j));
            */
        }
/*
        while(true) {
            i = chaine.indexOf(sep, j);
            if(i == -1) {
                info = chaine.substring(j, chaine.length());
                infos.add(info);
                break;
            }

            info = chaine.substring(j, i);
            j = i + 1;
            infos.add(info);
        }
*/
        return infos;
    }
}
