﻿#Область КорректировкаНУ

Процедура СформироватьДвиженияКорректировкаНУ(ДополнительныеСвойства, Движения, Отказ) Экспорт

	Проводки = Движения.Найти("Хозрасчетный");
	ТаблицаРеквизиты = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеквизиты;
	
	Параметры = ПодготовитьПараметрыСписаниеОС(ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];

	Если Не ЗначениеЗаполнено(Проводки) 
		Или Не ЗначениеЗаполнено(ТаблицаРеквизиты) Тогда
		Возврат;
	КонецЕсли;	
	
	// Список временных счетов.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК Счет
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	Хозрасчетный.Временный";
	МассивВременныеСчета = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Счет");
	
	Для Каждого Проводка Из Проводки Цикл
		
		// Корректировка по счету Дт.
		Если Проводка.КорректироватьНУ 
			И НЕ МассивВременныеСчета.Найти(Проводка.СчетДт) = Неопределено Тогда 
			Запись = Движения.КорректировкиНУ.Добавить();
			Запись.Период = Реквизиты.Период;
			Запись.Организация = Реквизиты.Организация;
			Запись.Счет = Проводка.СчетДт;
			Запись.ВидУчета = Перечисления.ВидыУчета.ВР;
			Запись.Сумма = Проводка.Сумма;
		КонецЕсли;	
		
		// Корректировка по счету Кт.
		Если Проводка.КорректироватьНУ И 
			НЕ МассивВременныеСчета.Найти(Проводка.СчетКт) = Неопределено Тогда 
			Запись = Движения.КорректировкиНУ.Добавить();
			Запись.Период = Реквизиты.Период;
			Запись.Организация = Реквизиты.Организация;
			Запись.Счет = Проводка.СчетКт;
			Запись.ВидУчета = Перечисления.ВидыУчета.ВР;
			Запись.Сумма = Проводка.Сумма;
		КонецЕсли;	
	КонецЦикла;

	Движения.КорректировкиНУ.Записывать = Истина;
	
КонецПроцедуры

Функция ПодготовитьПараметрыСписаниеОС(ТаблицаРеквизиты)

	Параметры = Новый Структура;

	// Подготовка таблицы Параметры.Реквизиты
	СписокОбязательныхКолонок = ""
	+ "Регистратор,"	// <ДокументСсылка.*> - документ-регистратор движений
	+ "Период,"			// <Дата> - период движений - дата документа
	+ "Организация";	// <СправочникСсылка.Организации>

	Параметры.Вставить("Реквизиты",
		ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаРеквизиты, СписокОбязательныхКолонок));

	Возврат Параметры;

КонецФункции

#КонецОбласти