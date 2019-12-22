﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ПрайсЛист.ПредставлениеНоменклатуры.Загрузить(Параметры.ПредставлениеНоменклатуры.Выгрузить());
	ПрайсЛист.ПечатьПрайсЛиста = Параметры.ПечатьПрайсЛиста;
	
	ПрайсЛист.КоличествоКолонок = Параметры.КоличествоКолонок;
	ПрайсЛист.КартинкаШирина = Параметры.КартинкаШирина;
	ПрайсЛист.КартинкаВысота = Параметры.КартинкаВысота;
	ПрайсЛист.ИзменятьРазмерПропорционально = Параметры.ИзменятьРазмерПропорционально;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КартинкаВысота", "Доступность", НЕ ПрайсЛист.ИзменятьРазмерПропорционально);
	
	ЭтоДиафильм = (ПрайсЛист.ПечатьПрайсЛиста = Перечисления.ВариантыПечатиПрайсЛиста.Диафильм);
	
	Для каждого Строка Из ПрайсЛист.ПредставлениеНоменклатуры Цикл
		
		Если Строка.Использование Тогда
			
			Если Строка.РеквизитНоменклатуры = "Наименование"
				ИЛИ Строка.РеквизитНоменклатуры = "НаименованиеПолное" Тогда
				
				Представление = Строка.РеквизитНоменклатуры;
				
			ИначеЕсли Строка.РеквизитНоменклатуры = "Комментарий" Тогда
				
				Представление = "Описание";
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НЕ ЭтоДиафильм Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтраницаКартинка", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаНастройкаКолонок", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Страницы", "ОтображениеСтраниц", ОтображениеСтраницФормы.Нет);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Представление.
//
&НаКлиенте
Процедура ПредставлениеПриИзменении(Элемент)
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры", "Наименование"));
	МассивСтрок[0].Использование = (Представление = "Наименование");
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры", "НаименованиеПолное"));
	МассивСтрок[0].Использование = (Представление = "НаименованиеПолное");
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры", "Комментарий"));
	МассивСтрок[0].Использование = (Представление = "Описание");
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода КартинкаШирина.
//
&НаКлиенте
Процедура КартинкаШиринаПриИзменении(Элемент)
	
	Если ПрайсЛист.ИзменятьРазмерПропорционально Тогда
		
		ПрайсЛист.КартинкаВысота = ПрайсЛист.КартинкаШирина * 5;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПрайсЛистИзменятьРазмерПропорционально.
//
&НаКлиенте
Процедура ПрайсЛистИзменятьРазмерПропорциональноПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КартинкаВысота", "Доступность", НЕ ПрайсЛист.ИзменятьРазмерПропорционально);
	Если ПрайсЛист.ИзменятьРазмерПропорционально Тогда
		
		ПрайсЛист.КартинкаВысота = ПрайсЛист.КартинкаШирина * 5;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	МассивСтрок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("Использование", Истина));
	Отказ = (МассивСтрок.Количество() = 0);
	Если Отказ Тогда
		
		ТекстОшибки = НСтр("ru = 'Необходимо выбрать минимум одно поле...'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
	Иначе
		
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("РезультатЗакрытия",			КодВозвратаДиалога.ОК);
		ПараметрыЗакрытия.Вставить("ПредставлениеНоменклатуры",	ПрайсЛист.ПредставлениеНоменклатуры);
		ПараметрыЗакрытия.Вставить("КоличествоКолонок",			ПрайсЛист.КоличествоКолонок);
		ПараметрыЗакрытия.Вставить("КартинкаШирина",			ПрайсЛист.КартинкаШирина);
		ПараметрыЗакрытия.Вставить("КартинкаВысота",			ПрайсЛист.КартинкаВысота);
		ПараметрыЗакрытия.Вставить("ИзменятьРазмерПропорционально",ПрайсЛист.ИзменятьРазмерПропорционально);
		
		Закрыть(ПараметрыЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти