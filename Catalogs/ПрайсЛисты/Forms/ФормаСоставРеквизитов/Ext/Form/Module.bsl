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
	
	ПрайсЛист.КоличествоКолонок = Параметры.КоличествоКолонок;
	ПрайсЛист.КартинкаШирина = Параметры.КартинкаШирина;
	ПрайсЛист.КартинкаВысота = Параметры.КартинкаВысота;
	ПрайсЛист.ИзменятьРазмерПропорционально = Параметры.ИзменятьРазмерПропорционально;
	
	МассивКолонок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры", "СвободныйОстаток"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВыводитьОстатки", "Доступность", МассивКолонок[0].Использование);
	
	МассивКолонок = ПрайсЛист.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("РеквизитНоменклатуры", "Картинка"));
	ИспользоватьКартинки = МассивКолонок[0].Использование;
	
	Если ИспользоватьКартинки Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПрайсЛистКартинкаВысота", "Доступность", НЕ ПрайсЛист.ИзменятьРазмерПропорционально);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПрайсЛистКартинкаШирина", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПрайсЛистКартинкаВысота", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПрайсЛистИзменятьРазмерПропорционально", "Доступность", Ложь);
		
	КонецЕсли;
	
	Элементы.ПрайсЛистПредставлениеНоменклатуры.ОтборСтрок = Новый ФиксированнаяСтруктура("СлужебныйУправлениеВидимостью", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода ПрайсЛистПредставлениеНоменклатуры.
//
&НаКлиенте
Процедура ПрайсЛистПредставлениеНоменклатурыПриИзменении(Элемент)
	
	ДанныеТекущейСтроки = Элементы.ПрайсЛистПредставлениеНоменклатуры.ТекущиеДанные;
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		
		Если ДанныеТекущейСтроки.РеквизитНоменклатуры = "СвободныйОстаток" Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВыводитьОстатки", "Доступность", ДанныеТекущейСтроки.Использование);
			
		ИначеЕсли ДанныеТекущейСтроки.РеквизитНоменклатуры = "Картинка" Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПрайсЛистКартинкаШирина", "Доступность", ДанныеТекущейСтроки.Использование);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПрайсЛистКартинкаВысота", "Доступность", ДанныеТекущейСтроки.Использование И (НЕ ПрайсЛист.ИзменятьРазмерПропорционально));
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПрайсЛистИзменятьРазмерПропорционально", "Доступность", ДанныеТекущейСтроки.Использование);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПрайсЛистИзменятьРазмерПропорционально.
//
&НаКлиенте
Процедура ПрайсЛистИзменятьРазмерПропорциональноПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПрайсЛистКартинкаВысота", "Доступность", НЕ ПрайсЛист.ИзменятьРазмерПропорционально);
	Если ПрайсЛист.ИзменятьРазмерПропорционально Тогда
		
		ПрайсЛист.КартинкаВысота = ПрайсЛист.КартинкаШирина * 5;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПрайсЛистКартинкаШирина.
//
&НаКлиенте
Процедура ПрайсЛистКартинкаШиринаПриИзменении(Элемент)
	
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
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		
	Иначе
		
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("РезультатЗакрытия", КодВозвратаДиалога.ОК);
		ПараметрыЗакрытия.Вставить("ПредставлениеНоменклатуры", ПрайсЛист.ПредставлениеНоменклатуры);
		ПараметрыЗакрытия.Вставить("КоличествоКолонок", ПрайсЛист.КоличествоКолонок);
		ПараметрыЗакрытия.Вставить("КартинкаШирина", ПрайсЛист.КартинкаШирина);
		ПараметрыЗакрытия.Вставить("КартинкаВысота", ПрайсЛист.КартинкаВысота);
		ПараметрыЗакрытия.Вставить("ИзменятьРазмерПропорционально", ПрайсЛист.ИзменятьРазмерПропорционально);
		
		Закрыть(ПараметрыЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти