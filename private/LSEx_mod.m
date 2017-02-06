function LSEx_mod
 
% 
% By using the Lindenmayer System Modifier you can change and modify 
% existing L-systems, by building rules to iteratively replace chains
% of n characters of the system with chains of m other ones. 
%     
% See detailed description about the usage and the parameters in the 
% User Manual or by pressing the help button.
% 
% For help and support feel free to contact: l-s-ex@gmx.co.uk
% 
% Version 1.0 by Michael Lindner 
% University of Reading, 2017
% Center for Integrative Neuroscience and Neurodynamics
%
%
%
% Copyright (c) 2017, Michael Lindner and James Douglas Saddy
%
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%    * Redistributions of source code must retain the above copyright
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright
%      notice, this list of conditions and the following disclaimer in
%      the documentation and/or other materials provided with the distribution
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%
% 

clear



global rule hmenu voc_length hfig huser rule_edit_user input_grammar ingram inrule actpath loaded_rules rule_def husers


ingram=0;
inrule=0;

BackgroundColor=[.7 .7 .7];
BackgroundColor2=[1 1 1];

ForegroundColor1=[1 0 0];
ForegroundColor2=[0 1 0];

actpath=pwd;

if exist('modifier_user_rules.mat', 'file') == 2
    load('modifier_user_rules.mat')
    loaded_rules=1;
else
    loaded_rules=0;
end

% grammars=get_default_rules;
cfg.figure_pos=calculate_figure_pos;

ver='1.0';


hfig=figure('Name', 'Lindenmayer systems modifier', ...
    'Visible', 'on', 'Units', 'pixels', ...
    'MenuBar', 'none', 'ToolBar', 'none', ...
    'Resize', 'off', 'NumberTitle', 'off',...
    'Position', cfg.figure_pos,...
    'Color',BackgroundColor);

% %
% % uicontrol('Style','text', ...
% %     'HorizontalAlignment','left', ...
% %     'Position',[20,430,200,20], ...
% %     'String','Specify L-system:',...
% %     'BackgroundColor',BackgroundColor);
% % GUI.grammar_type=uicontrol('Style', 'popupmenu',...
% %     'String', grammars.name,...
% %     'Value', 1,...
% %     'Units', 'pixels', ...
% %     'Position', [10,395,380,30],...
% %     'Callback',@grammar_function,...
% %     'BackgroundColor',BackgroundColor);
GUI.button_load=uicontrol('Style', 'pushbutton', ...
    'String', 'Load L-system (grammar) from .mat file', ...
    'Units', 'pixels',...
    'Position', [10,410,380,40],...
    'BackgroundColor',BackgroundColor2,...
    'ForegroundColor',ForegroundColor1,...
    'Callback',@load_system);


GUI.sytemload1=uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[20,385,360,15], ...
    'String','File: not loaded',...
    'BackgroundColor',BackgroundColor);
GUI.sytemload2=uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[20,370,360,15], ...
    'String','',...
    'BackgroundColor',BackgroundColor);



GUI.button_userdef=uicontrol('Style', 'pushbutton', ...
    'String', 'Define rules', ...
    'Units', 'pixels',...
    'Position', [10,320,380,40],...
    'BackgroundColor',BackgroundColor2,...
    'ForegroundColor',ForegroundColor1,...
    'Callback',@user_defined_select);

%
% %start value
uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[20,288,200,20], ...
    'String','Type of replacement:',...
    'BackgroundColor',BackgroundColor);
% GUI.start_value=uicontrol('Style', 'edit',...
%     'String', startvalue,...
%     'BackgroundColor',BackgroundColor2,...
%     'Position', [250,290,100,20]);

GUI.replace_type=uicontrol('Style', 'popupmenu',...
    'String', {'segmentwise','continous','continous (skip last n)'},...
    'Value', 2,...
    'Units', 'pixels', ...
    'Position', [220,290,170,20],...
    'BackgroundColor',BackgroundColor2);

% number of recursions
uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[20,258,200,20], ...
    'String','Max. number of recursions:',...
    'BackgroundColor',BackgroundColor);
GUI.rec_value=uicontrol('Style', 'edit',...
    'String', '',...
    'BackgroundColor',BackgroundColor2,...
    'Position', [250,260,80,20]);


% output folder
uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[20,210,200,20], ...
    'String','Specify output folder:',...
    'BackgroundColor',BackgroundColor);
GUI.output_folder=uicontrol('Style', 'edit',...
    'String', actpath,...
    'BackgroundColor',BackgroundColor2,...
    'Position', [20,190,280,20]);
GUI.button_browse=uicontrol('Style', 'pushbutton', ...
    'Tag', 'Browse',...
    'String', 'Browse', ...
    'Units', 'pixels',...
    'Position', [310,190,70,20],...
    'BackgroundColor',BackgroundColor2,...
    'Callback',@browse_button);


% output file name
uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[20,158,150,20], ...
    'String','Output file prefix:',...
    'BackgroundColor',BackgroundColor);
GUI.output_filename=uicontrol('Style', 'edit',...
    'String', 'mod_output',...
    'BackgroundColor',BackgroundColor2,...
    'Position', [160,160,200,20]);


% output file type
uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[20,130,150,20], ...
    'String','Select output type:',...
    'BackgroundColor',BackgroundColor);

GUI.checkbox_mat=uicontrol('Style','checkbox', ...
    'HorizontalAlignment','left', ...
    'Position',[200,130,20,20], ...
    'BackgroundColor',BackgroundColor,...
    'value',1);

uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[230,127,150,20], ...
    'String','MATLAB (.mat)',...
    'BackgroundColor',BackgroundColor);


GUI.checkbox_txt=uicontrol('Style','checkbox', ...
    'HorizontalAlignment','left', ...
    'Position',[200,110,20,20], ...
    'BackgroundColor',BackgroundColor,...
    'value',0);

uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[230,107,150,20], ...
    'String','Text (.txt)',...
    'BackgroundColor',BackgroundColor);



%
% GUI.checkbox_xls=uicontrol('Style','checkbox', ...
%     'HorizontalAlignment','left', ...
%     'Position',[200,100,20,20], ...
%     'value',0);
%
%
% uicontrol('Style','text', ...
%     'HorizontalAlignment','left', ...
%     'Position',[230,97,150,20], ...
%     'String','Excel (.xlsx)',...
%     'BackgroundColor',BackgroundColor);



% generate button
GUI.button_start=uicontrol('Style', 'pushbutton', ...
    'Tag', 'button_quit',...
    'String', 'Modify L-system', ...
    'Units', 'pixels',...
    'Position', [10,50,380,40],...
    'BackgroundColor',BackgroundColor2,...
    'Callback',@generate_function);

% about button - as pushbutton - bottom right
GUI.button_back=uicontrol('Style', 'pushbutton', ...
    'String', 'Back', ...
    'Units', 'pixels',...
    'Position', [10,20,100,20],...
    'BackgroundColor',BackgroundColor2,...
    'Callback',@back_function);


% about button - as pushbutton - bottom right
GUI.button_about=uicontrol('Style', 'pushbutton', ...
    'String', 'Help', ...
    'Units', 'pixels',...
    'Position', [150,20,100,20],...
    'BackgroundColor',BackgroundColor2,...
    'Callback',@about_function);


% quit button - as pushbutton - bottom right
GUI.button_quit=uicontrol('Style', 'pushbutton', ...
    'String', 'Quit', ...
    'Units', 'pixels',...
    'Position', [290,20,100,20],...
    'BackgroundColor',BackgroundColor2,...
    'Callback',@quit_function);


uicontrol('Style','text', ...
    'HorizontalAlignment','left', ...
    'Position',[10,3,390,10], ...
    'FontSize',6,...
    'ForegroundColor',[.55 .55 .55],...
    'String',['Lindenmayer generator v',ver,' by Michael Lindner and Doug Saddy, University of Reading'],...
    'BackgroundColor',BackgroundColor);


% %
% % grammar_function

a = axes;
set(a, 'Visible', 'off');
%# Stretch the axes over the whole figure.
set(a, 'Position', [0, 0, 1, 1]);
%# Switch off autoscaling.
set(a, 'Xlim', [0, 1], 'YLim', [0, 1]);
% line([0.05,.95], [0.71, 0.71], 'Parent', a, 'Color',[.6 .6 .6])
line([0.05,.95], [0.53, 0.53], 'Parent', a, 'Color',[.6 .6 .6])
line([0.05,.95], [0.215, 0.215], 'Parent', a, 'Color',[.6 .6 .6])

    function load_system(~,~)
        [FileName,PathName] = uigetfile('.mat','Select .mat file');
        loadname=fullfile(PathName,FileName);
        DAT=load(loadname);
        
        dlgname='Select cell containing the L-system';
        if isfield(DAT,'grammar')
            defaultans = {'grammar',num2str(size(DAT.grammar,1)),'1'};
        else
            defaultans = {'cellname','',''};
        end
        
        x = inputdlg({'Name of cell containing the L-system','row of cell','column of cell'},...
            dlgname, [1 50; 1 20; 1 20],defaultans);
        
        
        if ~iscell(eval(['DAT.',x{1}]))
            errordlg( [x{1},' is not a cell or not existing!'],'Input error')
        else
            
            cellinfo1=['File: ',FileName];
            cellinfo2=['Cell: ',x{1},' {',x{2},',',x{3},'}'];
            
            set(GUI.sytemload1,'String',cellinfo1)
            set(GUI.sytemload2,'String',cellinfo2)
            set(GUI.button_load, 'ForegroundColor',ForegroundColor2)
            
            eval(['input_grammar=DAT.',x{1},'(',x{2},',',x{3},')'])
            
            ingram=1;
            
            hfig;
        end
    end


    function generate_function(~,~)
        
        % generate grammar
        
        if ingram==0
            errordlg('Load grammar first!','Input error')
            error('Load grammar first!')
        end
        if inrule==0
            errordlg('Rules are not defined!','Input error')
            error('Rules are not defined!')
        end
        
        replacetype=get(GUI.replace_type,'Value');
        recursions=uint8(str2double(get(GUI.rec_value,'String')));
        if recursions<1
            errordlg('Number of recursion must be a positive intager value!','Input error')
            error('Number of recursion must be a positive intager value!')
        end
        
        
        folder=get(GUI.output_folder,'String');
        if isempty(folder)
            errordlg('You need to select an output folder!','Input error')
            error('You need to select an output folder!')
        end
        
        
        [grammar,grammar_length]=generator(input_grammar,rule,recursions,replacetype);
        
        % save grammar
        filename=get(GUI.output_filename,'String');
        
        fn_rep={'step','cont', 'contskip'};
        
        xxx=rand();
        
        if get(GUI.checkbox_mat,'Value')
            filename1=[filename,'_',fn_rep{replacetype},'_',datestr(now, 'dd-mmm-yyyy'),'.mat'];
            savename=fullfile(folder,filename1);
            if exist(savename, 'file') == 2
                savename=fullfile(folder,[filename,'_',fn_rep{replacetype},'_',datestr(now, 'dd-mmm-yyyy'),'_x',num2str(ceil(xxx*1000)),'.mat']);
            end
            save(savename,'grammar','grammar_length','rule')
        end
        if get(GUI.checkbox_txt,'Value')
            filename1=[filename,'_',fn_rep{replacetype},'_',datestr(now, 'dd-mmm-yyyy'),'_grammar.txt'];
            savename1=fullfile(folder,filename1);
            if exist(savename1, 'file') == 2
                savename1=fullfile(folder,[filename,'_',fn_rep{replacetype},'_',datestr(now, 'dd-mmm-yyyy'),'_x',num2str(ceil(xxx*1000)),'_grammar.txt']);
            end
            fid=fopen(savename1,'w');
            for ii=1:size(grammar,1)
                fprintf(fid,grammar{ii});
                fprintf(fid,'\r\n');
            end
            fclose(fid);
            filename2=[filename,'_',fn_rep{replacetype},'_',datestr(now, 'dd-mmm-yyyy'),'_grammar_length.txt'];
            savename2=fullfile(folder,filename2);
            if exist(savename1, 'file') == 2
                savename1=fullfile(folder,[filename,'_',fn_rep{replacetype},'_',datestr(now, 'dd-mmm-yyyy'),'_x',num2str(ceil(xxx*1000)),'_grammar_length.txt']);
            end
            fid=fopen(savename2,'w');
            for ii=1:size(grammar,1)
                fprintf(fid,num2str(grammar_length(ii)));
                fprintf(fid,'\r\n');
            end
            fclose(fid);
            filename3=[filename,'_',fn_rep{replacetype},'_',datestr(now, 'dd-mmm-yyyy'),'_rule.txt'];
            savename3=fullfile(folder,filename3);
            if exist(savename1, 'file') == 2
                savename3=fullfile(folder,[filename,'_',fn_rep{replacetype},'_',datestr(now, 'dd-mmm-yyyy'),'_x',num2str(ceil(xxx*1000)),'_rule.txt']);
            end
            fid=fopen(savename3,'w');
            for ii=1:size(rule,1)
                fprintf(fid,[rule{ii,1},' ---> ',rule{ii,2}]);
                fprintf(fid,'\r\n');
            end
            fclose(fid);
            
        end
        
    end


    function [gram,gram_length]=generator(start,rule,recursions,replacetype)
        
        disp('grammars:')
        
        %create empty cells and matrices
        gram=cell(recursions,1);
        gram_length=zeros(recursions,1);
        
        
        % get nr replace values from rule
        for ii=1:size(rule,1)
            l(ii)=length(rule{ii,1});
        end
        if replacetype==1
            if min(l)~=max(l)
                error('For segmentwise replacement all rules need to have the same source length (left side of the rules)!')
            end
        end
        maxl=max(l);
        
        % get and store start value
        if iscell(start)
            start=cell2mat(start);
        end
        x=start;
        gram{1}=x;
        gram_length(1)=length(x);
        disp(x)
        
        % start generating the recursions
        count=1;
        for rr=1:recursions
            
            count=count+1;
            
            if replacetype==1
                
                % calculate steps
                s2s=1:max(l):floor(length(x)/max(l))*max(l);
                
                c=cell(1,length(s2s));
                
                ccount=0;
                for ii=s2s
                    ccount=ccount+1;
                    ruledetect=0;
                    for rul=1:size(rule,1)
                        if strcmp(x(ii:ii+maxl-1),rule{rul,1})
                            c{ccount}=rule{rul,2};
                            ruledetect=1;
                        end
                    end
                    if ruledetect==0
                        c{ccount}=x(ii:ii+maxl-1);
                    end
                end
                
                x=cell2str(c);
                
                % store recursions
                gram{count}=x;
                gram_length(count)=length(x);
                disp(x)
                
            else
                
                ii=0;
                while ii<length(x)-max(l)
                    ii=ii+1;
                    % fprintf(['\n',num2str(ii)])
                    
                    r=0;
                    for rul=1:size(rule,1)
                        try %#ok<TRYNC>
                            % fprintf([' - ',num2str(rul),':',num2str(strcmp(x(ii:ii+length(rule{rul,1})-1),rule{rul,1}))])
                            if strcmp(x(ii:ii+length(rule{rul,1})-1),rule{rul,1})
                                c{ii}=rule{rul,2};
                                if replacetype==3
                                    ii=ii+length(rule{rul,1})-1;
                                end
                                r=r+1;
                            end
                        end
                    end
                    % fprintf([' - ',num2str(r)])
                    if r==0
                        c{ii}=x(ii);
                    end
                    
                end
                
                if replacetype==3
                    c2cut=find(cellfun(@isempty,c));
                    c(c2cut)=[];
                end
                
                x=cell2str(c);
                
                
                % store recursions
                gram{count}=x;
                gram_length(count)=length(x);
                disp(x)
                
            end
            
        end
        
    end



    function user_defined_select(~,~)
        
         cfg.figure_pos_user=cfg.figure_pos;
        
        cfg.figure_pos_user(1)=cfg.figure_pos_user(1)+50;
        cfg.figure_pos_user(4)= 100;
        cfg.figure_pos_user(3)= 275;
        
        screen_size=get(0,'Screensize');
        cfg.figure_pos_user(2)=screen_size(4)/2-cfg.figure_pos_user(4)/2;
            
        if loaded_rules==1
            husers=figure('Tag', 'Define rules', 'Name', 'Rule types', ...
                'Visible', 'on', 'Units', 'pixels', ...
                'MenuBar', 'none', 'ToolBar', 'none', ...
                'Resize', 'off', 'NumberTitle', 'off',...
                'Position', cfg.figure_pos_user,...
                'Color',BackgroundColor);
            
            % quit button - as pushbutton - bottom right
            button_classic=uicontrol('Style', 'pushbutton', ...
                'String', 'Define rule', ...
                'Units', 'pixels',...
                'Position', [25,10,100,80],...
                'Callback',@user_defined);
            button_extended=uicontrol('Style', 'pushbutton', ...
                'String', 'Load rule', ...
                'Units', 'pixels',...
                'Position', [150,10,100,80],...
                'Callback',@load_rule);
        else
            user_defined
        end
        
    end
        
    function user_defined(~,~)
        
        try
        close(husers)
        end
        
        rule=cell(1,1);
        
        voc_length_str = inputdlg('Enter length of vocabulary/Number of variables to replace:',...
            'Variables', [1 50]);
        voc_length = str2double(voc_length_str{:});
        
        cfg.figure_pos_user=cfg.figure_pos;
        
        cfg.figure_pos_user(1)=cfg.figure_pos_user(1)+50;
        cfg.figure_pos_user(4)= voc_length*40+80;
        upos=80:40:voc_length*40+80;
        
        screen_size=get(0,'Screensize');
        cfg.figure_pos_user(2)=screen_size(4)/2-cfg.figure_pos_user(4)/2;
        
        
        huser=figure('Tag', 'Define rules', 'Name', 'Define rules', ...
            'Visible', 'on', 'Units', 'pixels', ...
            'MenuBar', 'none', 'ToolBar', 'none', ...
            'Resize', 'off', 'NumberTitle', 'off',...
            'Position', cfg.figure_pos_user,...
            'Color',BackgroundColor);
        
        
        
        for voc=1:voc_length
            rule_edit_user(voc,1)=uicontrol('Style', 'edit',...
                'String', '',...
                'BackgroundColor',BackgroundColor2,...
                'Position', [50,upos(voc),100,20]);
            uicontrol('Style','text', ...
                'HorizontalAlignment','left', ...
                'Position',[200,upos(voc),40,20], ...
                'String','-->',...
                'BackgroundColor',BackgroundColor);
            rule_edit_user(voc,2)=uicontrol('Style', 'edit',...
                'String', '',...
                'BackgroundColor',BackgroundColor2,...
                'Position', [250,upos(voc),100,20]);
        end
        
        
        % quit button - as pushbutton - bottom right
        GUI.button_done=uicontrol('Style', 'pushbutton', ...
            'Tag', 'button_quit',...
            'String', 'Done', ...
            'Units', 'pixels',...
            'Position', [100,10,100,20],...
            'Callback',@create_rule_function);
        
        button_done=uicontrol('Style', 'pushbutton', ...
            'Tag', 'button_quit',...
            'String', 'Save rules', ...
            'Units', 'pixels',...
            'Position', [250,10,130,20],...
            'Callback',@save_rule_function);
        
        inrule=1;
    end


    function save_rule_function(~,~)
        create_rule_function
        rule_name = inputdlg('Name of the new rule?',...
            'Name of the new rule?', [1 100]);
        cd(actpath)
        if exist('modifier_user_rules.mat', 'file') == 2
            load('modifier_user_rules.mat')
            ro=length(rule_def.name)+1;
        else
            ro=1;
        end
        rule_def.name{ro}=['USER: ',rule_name{1}];
        rule_def.values{ro}=size(rule,1);
        rule_def.start{ro}=rule(1,1);
        rule_def.rules{ro}=rule;
        save('modifier_user_rules.mat','rule_def');
        
        try
            close(huser)
        end
    end

    function load_rule(~,~)
        
        close(husers)
        
        for ii=1:length(rule_def.name)
            rule_list{ii}=rule_def.name{ii};
        end
        
         cfg.figure_pos_user=cfg.figure_pos;
        
        cfg.figure_pos_user(1)=cfg.figure_pos_user(1)+50;
        cfg.figure_pos_user(4)= 100;
        cfg.figure_pos_user(3)= 400;
        
        screen_size=get(0,'Screensize');
        cfg.figure_pos_user(2)=screen_size(4)/2-cfg.figure_pos_user(4)/2;
        
        huser=figure('Tag', 'Define rules', 'Name', 'Define rules', ...
            'Visible', 'on', 'Units', 'pixels', ...
            'MenuBar', 'none', 'ToolBar', 'none', ...
            'Resize', 'off', 'NumberTitle', 'off',...
            'Position', cfg.figure_pos_user,...
            'Color',BackgroundColor);
        
        GUI.select_rule=uicontrol('Style', 'popupmenu',...
            'String', rule_list,...
            'Value', 1,...
            'Units', 'pixels', ...
            'Position', [10,60,380,30],...
            'Callback',@grammar_function,...
            'BackgroundColor',BackgroundColor2,...
            'Callback',@show_rule);
         GUI.load_button=uicontrol('Style', 'pushbutton', ...
            'String', 'Done', ...
            'Units', 'pixels',...
            'Position', [150,10,100,20],...
            'Callback',@load_rule_create);
        
        function load_rule_create(~,~)
            x=get(GUI.select_rule,'Value');
        %         rule=
            rule=rule_def.rules{x};
            close(huser)
        end
        function show_rule(~,~)
            x=get(GUI.select_rule,'Value');
            
            visrule=rule_def.rules{x};
            vis{1}=['Rules: ',rule_def.name{x}];
            for nn=1:size(visrule,1)
                vis{nn+1}=[visrule{nn,1},' ---> ',visrule{nn,2}];
            end
            msgbox(vis,'Rules:')
            huser
        end
        
        set(GUI.button_userdef, 'ForegroundColor',ForegroundColor2)
        hfig
        inrule=1;
    end

    function create_rule_function(~,~)
        
        user_rule=cell(voc_length,2);
        for voc=1:voc_length
            for rrr=1:2
                x=get(rule_edit_user((voc_length+1)-voc,rrr),'String');
                if isempty(x)
                    warndlg('All fields need to be filled in!')
                    
                else
                    user_rule{voc,rrr}=x;
                end
            end
        end
        rule=user_rule;
        
        set(GUI.button_userdef, 'ForegroundColor',ForegroundColor2)
        
        close(huser)
        hfig;
        
    end

    function back_function(~,~)
        close(hfig)
        hmenu;
        
    end

    function browse_button(~,~)
        
        folder_name = uigetdir('','Select output folder');
        set(GUI.output_folder,'String',folder_name)
    end


    function figure_pos=calculate_figure_pos
        % calculate figure position at ~ center of screen
        % get actual screen resolution
        screen_size=get(0,'Screensize');
        % lower left corner horizontal position
        figure_pos(1)=screen_size(3)/2-200;
        % lower left corner vertical position
        figure_pos(2)=screen_size(4)/2-200;
        % horizontal size of the GUI
        figure_pos(3)=400;
        % vertical size of the GUI
        figure_pos(4)=460;
    end


    function quit_function(~,~)
        clear all
        clc
        close all
        fprintf(['\n',...
            '################################################\n',...
            '#                                              #\n',...
            '#           Thank you for using the            #\n',...
            '#                                              #\n',...
            '#         Lindenmayer Exploration Kit          #\n',...
            '#                                              #\n',...
            '#       Doug Saddy and Michael Lindner         #\n',...
            '#                                              #\n',...
            '################################################\n'])
        pause(3)
    end

    function output=cell2str(input)
        output = '';
        input = cellstr(input);
        output = [repmat(sprintf(['%s'], input{1:end-1}), ...
            1, ~isscalar(input)), ...
            sprintf('%s', input{end})];
    end


    function about_function(~,~)
        
        about_text={'Lindenmayer System Modifier',...
            '',...
            'This tool is designed to modify Lindenmayer systems (grammar).',...
            'With this tool, rules can be defined to replace n with m number of',...
            'elements in the system.',...
            ' e.g. 111 with 1',...
            '      10  with 2',...
            '      110 with 10',...
            '      1   with 1011 etc.',...
            '',...
            'USAGE:',...
            '',...
            'First you need to load a system by using the Load L-system button.',...
            'You can easily load a Matlab output file from the Lindenmayer',...
            'System Generator. You can also load other systems, as long as the system',...
            'is stored in a matlab .mat file as a cell!',...
            '',...
            'You can define any rules for replacement by pressing',...
            'the "Define rules" button. After pressing the button',...
            'a new window opens where you can specify the number of',...
            'rules (replacements). Afterwards another window opens, where ',...
            'you can specify the rules',...
            ' e.g. 101 ---> 1',...
            '      010 ---> 0  etc.',...
            '',...
            'You can save the defined rules by pressing the "Save rules" button.',...
            'Then you can specify a name for the rule and it will be saved in a ',...
            'file called modifier_user_rules.mat. After creating this file by ',...
            'saving one or more rules, you will get the option to load the rules',...
            'after pressing the "Define Rules" button. The rules can be ',...
            'deleted by deleting the modifier_user_rules.mat file. BUT BE ',...
            'AWARE that all rules will be deleted by doing this!',...
            '',...
            'You have three options for types of replacement (how the rules',...
            'should be applied to the system):',...
            '1. segmentwise',...
            ' In the segmentwise replacement all vocabulars need to have the',...
            'same length. (e.g. 101, 111, 000, etc,). The grammar is then',...
            'cut into segments of the same length and the replacement',...
            'is then performed for each segment.',...
            '2, continuously',...
            ' In the continuous replacement the algorithm goes through the ',...
            'whole grammar elementwise and replaces the n elements from the',...
            'vocabulary with the m elements that you defined! Each element',...
            'will be checked and can be used more than once for a replacement!',...
            '',...
            'e.g. system:  001110110010011110010011110000',...
            '     rule: 111-->2 ; 110-->3 ; 100-->4',...
            '     results: 002310340040022340040022340000',...
            '',...
            '',...
            '3. continuously (skip last n)',...
            ' This type of replacement follows the same protocol as the one above, but',...
            'when identifying a match with your rule the next n-1 characters (length of',...
            'the vocabular) of the system are skipped. Here, each element will',...
            'only be used once for a replacement!',...
            '',...
            'e.g. system:  001110110010011110010011110000',...
            '     rule: 111-->2 ; 110-->3 ; 100-->4',...
            '     results: 0020304230423000',...
            '',...
            '',...
            'With the number of recursions you can specify how often the',...
            'rules should be used iteratively.',...
            '',...
            'You need to specify an output folder by typing in a path or',...
            'by using the browse button.',...
            'Furthermore, you can specify an output file prefix and the type of',...
            'output which should be stored. Either a Matlab .mat file,',...
            'a text file, or both are valid:',...
            'In the case of a .mat file, three variables are stored: a cell',...
            'with the grammar of each iteration, the rule and a vector with the',...
            'length of each iteration.',...
            'In the case of a .txt file, three output files are stored. One with',...
            'the grammar, one including the length of each iteration and one',...
            'containing the rule.',...
            '',...
            'After setting up all parameters, you simply need to press the',...
            'Modify L-system button.',...
            '','',...
            'This program is free software: you can redistribute it and/or modify',...
            'it under the terms of the GNU General Public License as published by',...
            'the Free Software Foundation, either version 3 of the License, or',...
            '(at your option) any later version.',...
            '',...
            'This program is distributed in the hope that it will be useful,',...
            'but WITHOUT ANY WARRANTY; without even the implied warranty of',...
            'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the',...
            'GNU General Public License for more details.',...
            '',...
            'You should have received a copy of the GNU General Public License',...
            'along with this program.  If not, see <http://www.gnu.org/licenses/>.',...
            '',...
            ['Version ',ver,' by Michael Lindner and Doug Saddy'],...
            'l-s-ex@gmx.co.uk',...
            'University of Reading, 2017',...
            'Center for Integrative Neuroscience and Neurodynamics',...
            'https://www.reading.ac.uk/cinn/cinn-home.aspx'};
        
        f=figure('menu','none','toolbar','none','name',...
            'Example script','NumberTitle','Off');
        hPan = uipanel(f,'Units','normalized');
        uicontrol(hPan, 'Style','listbox', ...
            'HorizontalAlignment','left', ...
            'Units','normalized', 'Position',[0 .2 1 .8], ...
            'String',about_text);
        
        
        btn=uicontrol('Style','pushbutton','String','Close',...
            'position',[10 10 200 20],...
            'Callback',@close_about);
        
        function close_about(hObject,callbackdata)
            close(f)
        end
    end

end







