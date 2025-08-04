#### Plot Funktionen zur Aufgabe Abfluss


#.# Ereignis Attert (drei Pegel)

plofun_event_attert <- function( loesung = TRUE)
{

  # Parameter für Rändern, Achsen und Grid
    schmal <- 0.5
    normal <- 5
    rechts <- 2
    achse <- seq(start(event), end(event), by=3*3600)
    xgrid <- seq(start(event), end(event), by=1*3600)

   layout(matrix(1:4,byrow=T), heights=c(2,2,2,3.25))    # zeilen verschieden hoch


  opa <- par(mar= c(schmal, normal, schmal, rechts)+0.1, cex=1.1)

  # 1 # Regen

   # midpoints at hour -> manipulating auxiliary data by shifting to the left
   # to mimick barplot
    #  barplot(event$Niederschlag,  ylim=c(1.1*max(event$Niederschlag),0), xaxt="n")   # barplot(plop,  ylim=c(1.1*max(event$Niederschlag),0), xaxt="n", col=4)
      plop <-  event$Niederschlag
      coredata(plop) <- c(coredata(event$Niederschlag[-1]),0)

    plot(event$Niederschlag,  ylim=c(1.1*max(event$Niederschlag),0), t="S",xaxt="n", col=4,
           ylab="N /mm") # endpoints of bar at hour

      # grid
      axis(1, at =xgrid, labels = F, tck = 1, lty = 2, col = "gray")
      axis(2, at =seq(0,15, 3), labels = F, tck = 1, lty = 2, col = "gray")

     legend("topright", "Niederschlag (Roodt)",  box.col="white", bg="white")

      # draw on top
       lines(event$Niederschlag,   t="S",xaxt="n", col=4) # endpoints of bar at hour

       lines(plop,   t="h",xaxt="n", col=4) # endpoints of bar at hour
       box(bty="o")

      if(loesung){
        abline(v=c(rain_start, rain_end), lty=c(2,1), lwd=2,col="orange")
        text(x = index(event$Niederschlag[8]), y= 12, adj=0,
             labels = expression(paste(sum(P)==25.5, " mm")),
             col="darkorange")
        legend("bottomright", paste(c("Beginn", "Ende"),"Niederschlag"),
               lty=c(2,1),col="orange", lwd=2,bty="n")
        }

   # # Abfluss

   par(mar= c(schmal, normal, schmal, rechts)+0.1)

    # 2 # Weierbach
     plot(event$Weierbach, xaxt="n", bty="l",  ylab="Q /(m3/s)",
           ylim=c(0,2.5e-2))
      if(loesung)
    {  abline(v=c(rain_start, rain_end), lty=c(2,1), lwd=2,col="orange")
      abline(v=end.wei, col=4, lty=3, lwd=2)
      # Polygon
      polygon( c(index(erg.wei$Q), rev(index(erg.wei$base))),
                  c(coredata(erg.wei$Q), rev(coredata(erg.wei$base))),col=4)

      legend("bottomright", "Direktabfluss",
            fill=4, bty="n")

      text(x=end.wei-3600, adj=1,   y=0.75*par("usr")[4],
           labels=bquote(t[c] ==  .(end.wei-rain_end) ~ "h"),
           col=4)
      text(x = end.wei+3600, adj=0,y=0.75*par("usr")[4],
           labels=bquote(V[direkt] == .(est.vol.wei) ~ "m3") ,
           col=4)
      }

       # Gitter
       axis(1, at =achse, labels = F, tck = 1, lty = 2, col = "gray")
          axis(1, at =xgrid, labels = F, tck = 1, lty = 2, col = "gray")
       axis(2, labels = F, tck = 1, lty = 2, col = "gray")

      # draw on top
       lines(event$Weierbach)
       box(bty="l")

     legend("topright", "Weierbach", bty="n")



    # 3  Colpach
      plot(event$Colpach, xaxt="n",  ylab="Q /(m3/s)",
           ylim=c(0,1.6)
           , yaxp=c(0,1.5, 5)
           )

       if(loesung)
       { abline(v=c(rain_start, rain_end), lty=c(2,1), lwd=2,col="orange")
         abline(v=end.col, col=4, lty=3, lwd=2)
         ## Polygon
         polygon( c(index(erg.col$Q), rev(index(erg.col$base))),
                  c(coredata(erg.col$Q), rev(coredata(erg.col$base))),col=4)

         text(x=end.col-3600, adj=1,   y=0.75*par("usr")[4],
               labels=bquote(t[c] ==  .(end.col-rain_end) ~ "h"),
               col=4)
         text(x = end.col+3600, adj=0,y=0.75*par("usr")[4],
               labels=bquote(V[direkt] == .(est.vol.col) ~ "m3") ,
               col=4)

         legend("bottomright","Ereignisende",
               lty=3,col=4, lwd=2,bty="n")
        }

      # Gitter
         axis(1, at =xgrid, labels = F, tck = 1, lty = 2, col = "gray")
         axis(2, labels = F, tck = 1, lty = 2, col = "gray", yaxp=c(0,1.5, 5))

      # draw on top
         lines(event$Colpach)
         box(bty="l")
         legend("topright", "Colpach", bty="n")

    # 4 # Useldingen
    par(mar= c(normal, normal, schmal, rechts)+0.1)
      plot(event$Useldange, xaxt="n",  ylab="Q /(m3/s)", xlab="",
            ylim=c(0,26))


       if(loesung)
       { # Linie regenereignis
        abline(v=c(rain_start, rain_end), lty=c(2,1), lwd=2,col="orange")
        abline(v=end.usl, col=4, lty=3, lwd=2)

        # linie baseflow / direkt
        lines(erg.usl$base, lwd=2,col=4)
         lines(erg.usl$Q, col=4, lwd=2)
        # Polygon
         polygon( c(index(erg.usl$Q), rev(index(erg.usl$base))),
                  c(coredata(erg.usl$Q), rev(coredata(erg.usl$base))),col=4)


         text(x=end.usl-3600, adj=1,            #x=mean(c(end.usl,rain_end)),
              y=0.75*par("usr")[4],
               labels=bquote(t[c] ==  .(difftime(end.usl,rain_end, units="hours")) ~ "h"),
               col=4)
          text(x = end.usl-3600, adj=1,y=0.5*par("usr")[4],
         labels=bquote(V[direkt] == .(est.vol.usl) ~ "m3") ,
         col=4)
         }

         # Gitter
         axis(1, at =achse, labels = F, tck = 1, lty = 2, col = "gray")
         axis(2, labels = F, tck = 1, lty = 2, col = "gray")


        # draw on top
         lines(event$Useldange)
        legend("topright", "Useldange",
              bty="n")
    # Achse
    axis(1,tck = 1, at=xgrid, labels = F,lty = 2, col = "gray")
    box()
    axis.POSIXct(1, event, at=achse, format="%H", cex=0.9)
     # labels at midnight
    dind <- grep("00", format(achse, "%H"))
    mtext(format(achse[dind], "%d. %b"), side = 1,
                               at=achse[dind],
                              adj=0, line=2.25, cex=1)

 }


#.# Ereignis Useldange

#  #### plotten - Version Lösung
 plofun_useldange <- function()
   { # funktion zum Erstellen eines Grundplots

    schmal <- 0.5
    normal <- 5
    rechts <- 2
    achse <- seq(start(event), end(event), by=3*3600)
    xgrid <- seq(start(event), end(event), by=1*3600)

    layout(matrix(1:2,byrow=T), heights=c(1.5,3.25)) # , widths=c(2.5)
   # zeilen verschieden hoch
   opa <- par(mar= c(schmal, normal, schmal, rechts)+0.1, cex=1.1)

   # Regen
    plot(event$Niederschlag,  ylim=c(1.1*max(event$Niederschlag),0), t="S",xaxt="n", col=4,
           ylab="N /mm") # endpoints of bar at hour

      # grid
      axis(1, at =xgrid, labels = F, tck = 1, lty = 2, col = "gray")
      axis(2, at =seq(0,15, 3), labels = F, tck = 1, lty = 2, col = "gray")


      ## draw on top
         lines(event$Niederschlag,   t="S",xaxt="n", col=4) # endpoints of bar at hour

      # midpoints at hour -> manipulating auxiliary data for plot
      # by shifting to the left

        plop <-  event$Niederschlag
        coredata(plop) <- c(coredata(event$Niederschlag[-1]),0)
        lines(plop,   t="h",xaxt="n", col=4) # endpoints of bar at hour
         box(bty="o")

     legend("topright", "Niederschlag (Roodt)",  box.col="white", bg="white",
            inset=c(0.02,0.1) )

    ## Abfluss  Useldingen

  par(mar= c(normal, normal, schmal, rechts)+0.1)

  plot(event$Useldange, xaxt="n",  ylab="Q /(m3/s)", xlab="",
            ylim=c(0,26))

         # Gitter
         axis(1, at =achse, labels = F, tck = 1, lty = 2, col = "gray")
         axis(2, labels = F, tck = 1, lty = 2, col = "gray")

    axis(1,tck = 1, at=xgrid, labels = F,lty = 2, col = "gray")
    box()
    axis.POSIXct(1, event, at=achse, format="%H", cex=0.9)
     # labels at midnight
    dind <- grep("00", format(achse, "%H"))
    mtext(format(achse[dind], "%d. %b"), side = 1,
                               at=achse[dind],
                              adj=0, line=2.25, cex=1)
     legend("topright", "Useldange",  box.col="white", bg="white", inset=c(0.02,0.1))
  }
  # end of plofun_useldange