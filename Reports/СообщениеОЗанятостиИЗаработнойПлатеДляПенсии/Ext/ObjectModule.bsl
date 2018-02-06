﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ФункцииОтчетовКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	БухгалтерскиеОтчеты.ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки);
КонецПроцедуры

#КонецОбласти

// Процедура - обработчик события ПриКомпоновкеРезультата.
// Выполняет компоновку.
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	КлючВарианта = НеОпределено;
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("КлючВарианта", КлючВарианта);

	ДокументРезультат.ТолькоПросмотр = Истина;
	ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СообщениеОЗанятостиИЗаработнойПлатеДляПенсии";
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	Если КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("Период") Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("Период", КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Период);
	КонецЕсли; 
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
		НастройкиОтчета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ЭлементыПользовательскихПолей = НастройкиОтчета.ПользовательскиеПоля.Элементы;
	
	СоответствиеПользовательскихПолей = Новый Соответствие;
	Для каждого Элемент Из ЭлементыПользовательскихПолей Цикл
		СоответствиеПользовательскихПолей.Вставить(Элемент.Заголовок, СтрЗаменить(Элемент.ПутьКДанным,".",""));
	КонецЦикла;

	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, , , Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ДанныеОтчета = Новый ДеревоЗначений;
	ПроцессорВывода.УстановитьОбъект(ДанныеОтчета);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);


	Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.СообщениеОЗанятостиИЗаработнойПлатеДляПенсии.ПФ_MXL_ОЗанятостиИЗаработнойПлате");
		
	Макеты = Новый Структура("Заголовок,Шапка,Данные,Подпись");
	
	Макеты.Шапка = Макет.ПолучитьОбласть("Шапка");
	Макеты.Заголовок = Макет.ПолучитьОбласть("Заголовок");
	Макеты.Данные = Макет.ПолучитьОбласть("Данные");
	Макеты.Подпись = Макет.ПолучитьОбласть("Подпись");
	сч = 1;
	Для каждого СтрокаДанных Из ДанныеОтчета.Строки Цикл
		Если сч = 1 Тогда 
			Макеты.Заголовок.Параметры.Заполнить(СтрокаДанных);
			Макеты.Заголовок.Параметры.АдресПредприятия = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(СтрокаДанных.Организация, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
			Индекс = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(СтрокаДанных.Организация, Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресОрганизации);
			Позиция=Найти(Индекс,","); 
			ПочтовыйИндекс=Лев(Индекс,Позиция-1);
			Макеты.Заголовок.Параметры.ПочтовыйИндекс = ПочтовыйИндекс;
			ДокументРезультат.Вывести(Макеты.Заголовок);
			
			ДокументРезультат.Вывести(Макеты.Шапка);
		КонецЕсли;
		
		Макеты.Данные.Параметры.Заполнить(СтрокаДанных);
		ДокументРезультат.Вывести(Макеты.Данные);
		
		Если сч = ДанныеОтчета.Строки.Количество() Тогда  
			Руководители  = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(СтрокаДанных.Организация, КонецДня(ТекущаяДата()));
			Макеты.Подпись.Параметры.Начальник 		= Руководители.Руководитель;
			Макеты.Подпись.Параметры.ГлБухгалтер 	= Руководители.ГлавныйБухгалтер;

			Макеты.Подпись.Параметры.Заполнить(СтрокаДанных);
			ДокументРезультат.Вывести(Макеты.Подпись);
		КонецЕсли;
		сч = сч + 1;
	КонецЦикла;
	
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецЕсли
