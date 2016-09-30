import os, shutil
from os import listdir, mkdir
from os.path import isdir

# get Pngs' names in current path and storage them in FileList
def getAllPngNames(path):
	existPngs = []
	for fileName in listdir(path):
		try:
			fileName.index('.png')
			existPngs.append(fileName)
		except ValueError:
			continue
	return existPngs

def changePngSimpleName(path):
	allPngs = getAllPngNames(path)
	for png in allPngs:
		src = path + '\\' + png
		dst = path + '\\' + png[-7:]
		shutil.move(src, dst)

def getAllFloderNames(path):
	existFloders = []
	for floderName in listdir(path):
		if isdir(path + '\\' + floderName):
			existFloders.append(floderName)
	return existFloders

def changPngRecursively(path):
	existFloder = getAllFloderNames(path)
	changePngSimpleName(path)
	# move files in sub path
	for floder in existFloder:
		changPngRecursively(path + '\\' + floder)

changPngRecursively('.')