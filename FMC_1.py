from functionsFMC import *
from plotFMC import *



str1=30.0
dip1=36.0
rake1=65.0
anX, anY, anZ, dx, dy, dz = pl2nd(str1,dip1,rake1)
px, py, pz, tx, ty, tz, bx, by, bz = nd2pt(anX,anY,anZ,dx,dy,dz)

trendp,plungp=ca2ax(px,py,pz)
trendt,plungt=ca2ax(tx,ty,tz)
trendb,plungb=ca2ax(bx,by,bz)

# x, y Kaverina diagram
x_kav,y_kav=kave(plungt,plungb,plungp)

# storing data for the plot
xplot = x_kav
yplot = y_kav

size = 15
color = 'red'
fig=circles(xplot,yplot,size,color,'test')
plt.savefig('test.png')
plt.close()
