
#include "mAMainWindow.h"
#include "ui_mAMainWindow.h"

#include <QMessageBox>


mAMainWindow::mAMainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::mAMainWindow),
    ma(new miniAudicle)
{
    vm_on = false;

    ui->setupUi(this);

    ui->actionAdd_Shred->setEnabled(false);
    ui->actionRemove_Shred->setEnabled(false);
    ui->actionReplace_Shred->setEnabled(false);

    newFile();
}

mAMainWindow::~mAMainWindow()
{
    if(vm_on)
    {
        ma->stop_vm();
    }

    // manually close all windows
    // each window has a pointer to the miniAudicle object
    // so we have to delete them before deleting the miniAudicle
    for(int i = ui->tabWidget->count()-1; i >= 0; i--)
    {
        ui->tabWidget->removeTab(i);
    }

    delete ui;
    ui = NULL;
    delete ma;
    ma = NULL;
}


void mAMainWindow::exit()
{
    qApp->exit(0);
}

void mAMainWindow::newFile()
{
    mADocumentView * documentView = new mADocumentView(0, "untitled", NULL, ma);
    documentView->setTabWidget(ui->tabWidget);

    ui->tabWidget->addTab(documentView, QIcon(), "untitled");
    ui->tabWidget->setCurrentIndex(ui->tabWidget->count()-1);

    documentView->show();
}

void mAMainWindow::openFile(const QString &path)
{
    QString fileName = path;

    if (fileName.isNull())
        fileName = QFileDialog::getOpenFileName(this,
            tr("Open File"), "", "ChucK Scripts (*.ck)");

    if (!fileName.isEmpty()) {
        QFile * file = new QFile(fileName);
        if (file->open(QFile::ReadWrite | QFile::Text))
        {
            QFileInfo fileInfo(fileName);
            mADocumentView * documentView = new mADocumentView(0, fileInfo.fileName().toStdString(), file, ma);
            documentView->setTabWidget(ui->tabWidget);

            ui->tabWidget->addTab(documentView, QIcon(), fileInfo.fileName());
            ui->tabWidget->setCurrentIndex(ui->tabWidget->count()-1);

            documentView->show();
        }
    }
}

void mAMainWindow::closeFile()
{
    closeFile(ui->tabWidget->currentIndex());
}

void mAMainWindow::closeFile(int i)
{
    mADocumentView * view = (mADocumentView *) ui->tabWidget->widget(i);

    if(view == NULL)
        return;

    if(view->isDocumentModified())
    {
        QMessageBox msgBox;
        msgBox.setText("The document has been modified.");
        msgBox.setInformativeText("Do you want to save your changes?");
        msgBox.setStandardButtons(QMessageBox::Save | QMessageBox::Discard | QMessageBox::Cancel);
        msgBox.setDefaultButton(QMessageBox::Save);
        msgBox.setIcon(QMessageBox::Warning);
        int ret = msgBox.exec();

        if(ret == QMessageBox::Save)
        {
            view->save();
        }
        else if(ret == QMessageBox::Cancel)
        {
            return;
        }
    }

    ui->tabWidget->removeTab(i);
    delete view;
}

void mAMainWindow::saveFile()
{
    mADocumentView * view = (mADocumentView *) ui->tabWidget->currentWidget();

    if(view == NULL)
        return;

    view->save();
}

#pragma mark

void mAMainWindow::addCurrentDocument()
{
    ((mADocumentView *) ui->tabWidget->currentWidget())->add();
}

void mAMainWindow::replaceCurrentDocument()
{
    ((mADocumentView *) ui->tabWidget->currentWidget())->replace();
}

void mAMainWindow::removeCurrentDocument()
{
    ((mADocumentView *) ui->tabWidget->currentWidget())->remove();
}

void mAMainWindow::toggleVM()
{
    if(!vm_on)
    {
        if(ma->start_vm())
        {
            ui->actionStart_Virtual_Machine->setText("Stop Virtual Machine");

            ui->actionAdd_Shred->setEnabled(true);
            ui->actionRemove_Shred->setEnabled(true);
            ui->actionReplace_Shred->setEnabled(true);

            vm_on = true;
        }
    }
    else
    {
        ma->stop_vm();

        ui->actionStart_Virtual_Machine->setText("Start Virtual Machine");

        ui->actionAdd_Shred->setEnabled(false);
        ui->actionRemove_Shred->setEnabled(false);
        ui->actionReplace_Shred->setEnabled(false);

        vm_on = false;
    }
}

