﻿
#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы Физического лица

Процедура ФизическиеЛицаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	СотрудникиФормыБазовый.ФизическиеЛицаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
КонецПроцедуры

Процедура ФизическиеЛицаПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	СотрудникиФормыБазовый.ФизическиеЛицаПриЧтенииНаСервере(Форма, ТекущийОбъект);
КонецПроцедуры

Процедура ФизическиеЛицаПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	СотрудникиФормыБазовый.ФизическиеЛицаПриЗаписиНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи);	
КонецПроцедуры

Процедура ФизическиеЛицаПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	СотрудникиФормыБазовый.ФизическиеЛицаПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

Процедура ЛичныеДанныеФизическогоЛицаПриЗаписи(Форма, ФизическоеЛицоСсылка, Организация) Экспорт
	СотрудникиФормыБазовый.ЛичныеДанныеФизическогоЛицаПриЗаписи(Форма, ФизическоеЛицоСсылка, Организация);
КонецПроцедуры
	
Процедура ПрочитатьДанныеСвязанныеСФизЛицом(Форма, Организация, ИзФормыСотрудника) Экспорт
	СотрудникиФормыБазовый.ПрочитатьДанныеСвязанныеСФизЛицом(Форма, Организация, ИзФормыСотрудника);
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	// из документа Увольнения отборы по Физлицу
	Если Параметры.Свойство("ТолькоПринятые") И Параметры.ТолькоПринятые И Параметры.Отбор.Свойство("ДатаПримененияОтбора") Тогда 
		
		Запрос = Новый Запрос;

		ТекстЗапросаУсловий = "НЕ Сотрудники.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)";
				
		Если Параметры.Свойство("СтрокаПоиска") И НЕ ПустаяСтрока(Параметры.СтрокаПоиска) Тогда
			УсловияПодбора = "";
			МетаданныеОбъекта = Метаданные.Справочники.ФизическиеЛица;
			Для каждого Поле Из МетаданныеОбъекта.ВводПоСтроке Цикл
				УсловияПодбора = УсловияПодбора + ?(ПустаяСтрока(УсловияПодбора), "", Символы.ПС + "ИЛИ ") + "(Сотрудники.ФизЛицо." + Поле.Имя + " ПОДОБНО &СтрокаПоиска)";
			КонецЦикла;
			Если НЕ ПустаяСтрока(УсловияПодбора) Тогда
				ТекстЗапросаУсловий = ?(ПустаяСтрока(ТекстЗапросаУсловий), "", ТекстЗапросаУсловий + "
				|	И ") + "(" + УсловияПодбора + ")";
			КонецЕсли; 
			Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска + "%");
		КонецЕсли; 
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	Сотрудники.ФизЛицо КАК Значение,
		|	Сотрудники.ФизЛицо.Наименование + "" ("" + Сотрудники.ФизЛицо.Код + "")"" КАК Представление
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&Период,Организация = &Организация) КАК Сотрудники";
		Если НЕ ПустаяСтрока(ТекстЗапросаУсловий) Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|ГДЕ
			|	" + ТекстЗапросаУсловий;
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + "
			|УПОРЯДОЧИТЬ ПО
			|	Представление";

		Запрос.УстановитьПараметр("Период", Параметры.Отбор.ДатаПримененияОтбора);
		Запрос.УстановитьПараметр("Организация", Параметры.Отбор.Организация);
		
		Запрос.Текст = ТекстЗапроса;
		
		ДанныеВыбора = Новый СписокЗначений;
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ДанныеВыбора.Добавить(Выборка.Значение, Выборка.Представление);
		КонецЦикла;
		
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
