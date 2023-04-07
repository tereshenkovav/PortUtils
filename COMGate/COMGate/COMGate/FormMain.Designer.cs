namespace COMGate
{
    partial class FormMain
    {
        /// <summary>
        /// Требуется переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Обязательный метод для поддержки конструктора - не изменяйте
        /// содержимое данного метода при помощи редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            this.butDetect = new System.Windows.Forms.Button();
            this.comboPorts = new System.Windows.Forms.ComboBox();
            this.butOpen = new System.Windows.Forms.Button();
            this.butClose = new System.Windows.Forms.Button();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.label1 = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.butGetFile = new System.Windows.Forms.Button();
            this.butSendFile = new System.Windows.Forms.Button();
            this.textLog = new System.Windows.Forms.TextBox();
            this.textMsg = new System.Windows.Forms.TextBox();
            this.butSend = new System.Windows.Forms.Button();
            this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
            this.butGetIncom = new System.Windows.Forms.Button();
            this.button1 = new System.Windows.Forms.Button();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // butDetect
            // 
            this.butDetect.Location = new System.Drawing.Point(234, 11);
            this.butDetect.Name = "butDetect";
            this.butDetect.Size = new System.Drawing.Size(132, 23);
            this.butDetect.TabIndex = 0;
            this.butDetect.Text = "Перечитать порты";
            this.butDetect.UseVisualStyleBackColor = true;
            this.butDetect.Click += new System.EventHandler(this.butDetect_Click);
            // 
            // comboPorts
            // 
            this.comboPorts.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboPorts.FormattingEnabled = true;
            this.comboPorts.Location = new System.Drawing.Point(107, 13);
            this.comboPorts.Name = "comboPorts";
            this.comboPorts.Size = new System.Drawing.Size(121, 21);
            this.comboPorts.TabIndex = 1;
            // 
            // butOpen
            // 
            this.butOpen.Location = new System.Drawing.Point(13, 51);
            this.butOpen.Name = "butOpen";
            this.butOpen.Size = new System.Drawing.Size(116, 24);
            this.butOpen.TabIndex = 2;
            this.butOpen.Text = "Открыть порт";
            this.butOpen.UseVisualStyleBackColor = true;
            this.butOpen.Click += new System.EventHandler(this.butOpen_Click);
            // 
            // butClose
            // 
            this.butClose.Location = new System.Drawing.Point(145, 51);
            this.butClose.Name = "butClose";
            this.butClose.Size = new System.Drawing.Size(116, 24);
            this.butClose.TabIndex = 6;
            this.butClose.Text = "Закрыть порт";
            this.butClose.UseVisualStyleBackColor = true;
            this.butClose.Visible = false;
            this.butClose.Click += new System.EventHandler(this.butClose_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label1.Location = new System.Drawing.Point(13, 11);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(74, 13);
            this.label1.TabIndex = 8;
            this.label1.Text = "Порты COM";
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.butGetIncom);
            this.panel1.Controls.Add(this.butGetFile);
            this.panel1.Controls.Add(this.butSendFile);
            this.panel1.Controls.Add(this.textLog);
            this.panel1.Controls.Add(this.textMsg);
            this.panel1.Controls.Add(this.butSend);
            this.panel1.Location = new System.Drawing.Point(13, 92);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(466, 368);
            this.panel1.TabIndex = 9;
            // 
            // butGetFile
            // 
            this.butGetFile.Location = new System.Drawing.Point(161, 59);
            this.butGetFile.Name = "butGetFile";
            this.butGetFile.Size = new System.Drawing.Size(116, 23);
            this.butGetFile.TabIndex = 12;
            this.butGetFile.Text = "Принять файл";
            this.butGetFile.UseVisualStyleBackColor = true;
            this.butGetFile.Click += new System.EventHandler(this.butGetFile_Click);
            // 
            // butSendFile
            // 
            this.butSendFile.Location = new System.Drawing.Point(14, 59);
            this.butSendFile.Name = "butSendFile";
            this.butSendFile.Size = new System.Drawing.Size(130, 23);
            this.butSendFile.TabIndex = 11;
            this.butSendFile.Text = "Послать файл";
            this.butSendFile.UseVisualStyleBackColor = true;
            this.butSendFile.Click += new System.EventHandler(this.butSendFile_Click);
            // 
            // textLog
            // 
            this.textLog.Location = new System.Drawing.Point(14, 87);
            this.textLog.Multiline = true;
            this.textLog.Name = "textLog";
            this.textLog.ReadOnly = true;
            this.textLog.Size = new System.Drawing.Size(418, 254);
            this.textLog.TabIndex = 10;
            // 
            // textMsg
            // 
            this.textMsg.Location = new System.Drawing.Point(108, 14);
            this.textMsg.Name = "textMsg";
            this.textMsg.Size = new System.Drawing.Size(324, 20);
            this.textMsg.TabIndex = 9;
            this.textMsg.Text = "dark red fox jump over lazy dog";
            this.textMsg.Visible = false;
            // 
            // butSend
            // 
            this.butSend.Location = new System.Drawing.Point(14, 14);
            this.butSend.Name = "butSend";
            this.butSend.Size = new System.Drawing.Size(75, 23);
            this.butSend.TabIndex = 8;
            this.butSend.Text = "send";
            this.butSend.UseVisualStyleBackColor = true;
            this.butSend.Visible = false;
            // 
            // butGetIncom
            // 
            this.butGetIncom.Location = new System.Drawing.Point(300, 59);
            this.butGetIncom.Name = "butGetIncom";
            this.butGetIncom.Size = new System.Drawing.Size(122, 23);
            this.butGetIncom.TabIndex = 13;
            this.butGetIncom.Text = "Трансляция входа";
            this.butGetIncom.UseVisualStyleBackColor = true;
            this.butGetIncom.Click += new System.EventHandler(this.butGetIncom_Click);
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(359, 41);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 10;
            this.button1.Text = "button1";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // FormMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(488, 467);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.butClose);
            this.Controls.Add(this.butOpen);
            this.Controls.Add(this.comboPorts);
            this.Controls.Add(this.butDetect);
            this.Name = "FormMain";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Пересылка данных через COM-порт";
            this.Load += new System.EventHandler(this.FormMain_Load);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button butDetect;
        private System.Windows.Forms.ComboBox comboPorts;
        private System.Windows.Forms.Button butOpen;
        private System.Windows.Forms.Button butClose;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button butSendFile;
        private System.Windows.Forms.TextBox textLog;
        private System.Windows.Forms.TextBox textMsg;
        private System.Windows.Forms.Button butSend;
        private System.Windows.Forms.Button butGetFile;
        private System.Windows.Forms.SaveFileDialog saveFileDialog1;
        private System.Windows.Forms.Button butGetIncom;
        private System.Windows.Forms.Button button1;
    }
}

