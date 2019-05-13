﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Подразделение = Объект.Подразделение;
	МОЛ = Объект.МОЛ;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборОСПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьОСИзХранилища(АдресЗапасовВХранилище, "ОС");
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
КонецПроцедуры  

// Процедура - обработчик события НачалоВыбора поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Подразделение.
//
&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	// Значение реквизита не изменилось
	Если Объект.Подразделение = Подразделение Тогда 
		Возврат;
	КонецЕсли;	

	Если Объект.ОС.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросОчиститьТабличнуюЧастьОС", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе 
		Подразделение = Объект.Подразделение;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода МОЛ.
//
&НаКлиенте
Процедура МОЛПриИзменении(Элемент)
	// Значение реквизита не изменилось
	Если Объект.МОЛ = МОЛ Тогда 
		Возврат;
	КонецЕсли;	

	Если Объект.ОС.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросОчиститьТабличнуюЧастьОС", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе 
		МОЛ = Объект.МОЛ;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОС

// Процедура - обработчик события ПриИзменении поля ввода ОССтоимостьПоДаннымУчета.
//
&НаКлиенте
Процедура ОССтоимостьПоДаннымУчетаПриИзменении(Элемент)
	РассчитатьИзлишекНедостача(Элементы.ОС.ТекущиеДанные);
КонецПроцедуры 

// Процедура - обработчик события ПриИзменении поля ввода ОСНаличиеПоДаннымУчета.
//
&НаКлиенте
Процедура ОСНаличиеПоДаннымУчетаПриИзменении(Элемент)
	РассчитатьИзлишекНедостача(Элементы.ОС.ТекущиеДанные);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ОССтоимостьФактическая.
//
&НаКлиенте
Процедура ОССтоимостьФактическаяПриИзменении(Элемент)
	РассчитатьИзлишекНедостача(Элементы.ОС.ТекущиеДанные);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ОСНаличиеФактическое.
//
&НаКлиенте
Процедура ОСНаличиеФактическоеПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;	
	
	Если СтрокаТабличнойЧасти.НаличиеФактическое Тогда
		Если НЕ СтрокаТабличнойЧасти.СтоимостьПоДаннымУчета = 0 Тогда 
			СтрокаТабличнойЧасти.СтоимостьФактическая = СтрокаТабличнойЧасти.СтоимостьПоДаннымУчета;
		КонецЕсли;	
	Иначе
		СтрокаТабличнойЧасти.СтоимостьФактическая = 0;
	КонецЕсли;
	
	РассчитатьИзлишекНедостача(СтрокаТабличнойЧасти); 	
	
КонецПроцедуры

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)
	// получаем текущую строку
	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;
	МассивОсновныхСредств = Новый Массив;
	МассивОсновныхСредств.Добавить(СтрокаТабличнойЧасти.ОсновноеСредство);
	ДополнитьСтрокиНаСервере(МассивОсновныхСредств);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик события Действие команды Подбор
//
&НаКлиенте
Процедура ПодборОС(Команда)
	УправлениеВнеоборотнымиАктивамиКлиент.ОткрытьПодбор(ЭтаФорма, "ОС");  
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткамОС(Команда)	
	
	Если Объект.ОС.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьОСПоОстаткам", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет перезаполнена. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьПоОстаткамОСНаСервере();
	КонецЕсли;
	
КонецПроцедуры

// Процедура производит заполнение 
// колонок табличной части с данными учета для списка основных средств, 
// заданного в табличной части.
&НаКлиенте
Процедура ЗаполнитьФактическиеДанныеОС(Команда)
	Отказ = Ложь;
	
	Если Объект.ОС.Количество() = 0  Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена табличная часть ""Основные средства""! Расчет документа отменен.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.ОС",,Отказ);		
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	

	ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьОСФактическиеДанные", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Фактические данные будут перезаполнены. Продолжить выполнение операции?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);

КонецПроцедуры // ЗаполнитьФактическиеДанныеОС() 

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьОСПоОстаткам(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.ОС.Очистить();
		ЗаполнитьПоОстаткамОСНаСервере();
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьОСФактическиеДанные(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Для Каждого СтрокаТабличнойЧасти Из Объект.ОС Цикл		
			СтрокаТабличнойЧасти.СтоимостьФактическая 	= СтрокаТабличнойЧасти.СтоимостьПоДаннымУчета;
			СтрокаТабличнойЧасти.НаличиеФактическое   	= СтрокаТабличнойЧасти.НаличиеПоДаннымУчета;				
			СтрокаТабличнойЧасти.НедостачаСумма   		= 0;
		КонецЦикла;
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросОчиститьТабличнуюЧастьОС(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Подразделение = Объект.Подразделение;
		МОЛ = Объект.МОЛ;
		Объект.ОС.Очистить();
	Иначе
		// Отмена изменения - возврат прежних значений
		Объект.Подразделение = Подразделение;
		Объект.МОЛ = МОЛ;
	КонецЕсли; 
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// Процедура - Рассчитать излишек недостача
//
// Параметры:
//  СтрокаТабличнойЧасти - 	 - 
//
&НаКлиенте
Процедура РассчитатьИзлишекНедостача(СтрокаТабличнойЧасти)
	
	РазницаПоНаличию   = Число(СтрокаТабличнойЧасти.НаличиеФактическое) - Число(СтрокаТабличнойЧасти.НаличиеПоДаннымУчета);
	РазницаПоСтоимости = СтрокаТабличнойЧасти.СтоимостьФактическая - СтрокаТабличнойЧасти.СтоимостьПоДаннымУчета;
	
	СтрокаТабличнойЧасти.ИзлишекСумма        = ?(РазницаПоСтоимости > 0,  РазницаПоСтоимости, 0);
	СтрокаТабличнойЧасти.НедостачаСумма 	   = ?(РазницаПоСтоимости < 0, -РазницаПоСтоимости, 0); 

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОстаткамОСНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьПоОстаткамОС();
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры

// Процедура получает список ОС из временного хранилища
//
&НаСервере
Процедура ПолучитьОСИзХранилища(АдресЗапасовВХранилище, ИмяТабличнойЧасти)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	МассивОсновныхСредств = Новый Массив;
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект.ОС.НайтиСтроки(Новый Структура("ОсновноеСредство", СтрокаЗагрузки.ОсновноеСредство));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		СтрокаТабличнойЧасти = Объект.ОС.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
		МассивОсновныхСредств.Добавить(СтрокаТабличнойЧасти.ОсновноеСредство);
	КонецЦикла;
	
	ДополнитьСтрокиНаСервере(МассивОсновныхСредств);
	
	// Заполнение данных инвентаризации
	Для Каждого СтрокаТабличнойЧасти Из Объект.ОС Цикл 
		СтрокаТабличнойЧасти.ИзлишекСумма = 0;	
		СтрокаТабличнойЧасти.НедостачаСумма = 0;	
		СтрокаТабличнойЧасти.СтоимостьПоДаннымУчета = СтрокаТабличнойЧасти.ПервоначальнаяСтоимость;	
		СтрокаТабличнойЧасти.СтоимостьФактическая = СтрокаТабличнойЧасти.ПервоначальнаяСтоимость;	
		СтрокаТабличнойЧасти.НаличиеПоДаннымУчета = Истина;	
		СтрокаТабличнойЧасти.НаличиеФактическое = Истина;	
	КонецЦикла;	
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

// Процедура заполняет строки
//
// Параметры:
//  МассивОсновныхСредств  - Массив - массив ОС, по которым нужно заполнить строки, если не указано- заполняются все строки
//
&НаСервере
Процедура ДополнитьСтрокиНаСервере(МассивОсновныхСредств = Неопределено)
	Если МассивОсновныхСредств = Неопределено Тогда 
		МассивОсновныхСредств = Объект.ОС.Выгрузить().ВыгрузитьКолонку("ОсновноеСредство");
	КонецЕсли;		
	
	Если МассивОсновныхСредств.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;	
	
	УправлениеВнеоборотнымиАктивами.ЗаполнитьДанныеОсновныхСредствВТабличнойЧасти(Объект.Ссылка, ДатаДокумента, Объект.Организация, Объект.ОС, МассивОсновныхСредств);
КонецПроцедуры // ДополнитьСтрокиНаСервере()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыКомиссия

// Процедура - обработчик события команды ПодборФизическихЛиц.
// Открывает форму выбора.
//
&НаКлиенте
Процедура ПодборФизическихЛиц(Команда)

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыФормы, Элементы.Комиссия);

КонецПроцедуры

// Процедура - обработчик события ПередУдалением таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияПередУдалением(Элемент, Отказ)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;
	Если ТекущаяСтрокаТЧ.Председатель Тогда
		ИндексУдаляемойСтроки = Объект.Комиссия.Индекс(ТекущаяСтрокаТЧ);
		КоличествоСтрок = Объект.Комиссия.Количество() - 1;

		Если КоличествоСтрок > 0 Тогда
			Если ИндексУдаляемойСтроки <= КоличествоСтрок - 1 Тогда
				ИндексНовогоПредседателя = ИндексУдаляемойСтроки + 1;
			Иначе
				ИндексНовогоПредседателя = КоличествоСтрок - 1;
			КонецЕсли;
			Объект.Комиссия[ИндексНовогоПредседателя].Председатель = Истина;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриНачалеРедактирования таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если Копирование Тогда
		ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;
		ТекущаяСтрокаТЧ.ФизЛицо = Неопределено;
		ТекущаяСтрокаТЧ.Председатель = Ложь;
	Иначе // Создание заново
		Если Объект.Комиссия.Количество() = 1 Тогда
			Объект.Комиссия[0].Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Строки = Объект.Комиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));

	Если Строки.Количество() > 0 Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Физическое лицо ""%1"" уже подобрано!'"), ВыбранноеЗначение);
		ПоказатьПредупреждение(, ТекстСообщения, 60);
	Иначе
		НоваяСтрока = Объект.Комиссия.Добавить();
		НоваяСтрока.ФизЛицо = ВыбранноеЗначение;
		Если Объект.Комиссия.Количество() = 1 Тогда
			НоваяСтрока.Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Председатель.
//
&НаКлиенте
Процедура КомиссияПредседательПриИзменении(Элемент)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;

	Если НЕ ТекущаяСтрокаТЧ.Председатель Тогда
		// Снимать флажок нельзя
		ТекущаяСтрокаТЧ.Председатель = Истина;
		Возврат;
	КонецЕсли;

	Для каждого СтрокаТЧ Из Объект.Комиссия Цикл
		Если СтрокаТЧ.НомерСтроки <> ТекущаяСтрокаТЧ.НомерСтроки Тогда
			СтрокаТЧ.Председатель = Ложь;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФизЛицо.
//
&НаКлиенте
Процедура КомиссияФизЛицоПриИзменении(Элемент)

	Если Объект.Комиссия.Количество() = 1 Тогда
		Объект.Комиссия[0].Председатель = Истина;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора поля ввода ФизЛицо.
//
&НаКлиенте
Процедура КомиссияФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;

	Если ТекущаяСтрокаТЧ.ФизЛицо <> ВыбранноеЗначение Тогда

		СтрокиТабличнойЧасти = Объект.Комиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));

		Если СтрокиТабличнойЧасти.Количество() > 0 Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Физическое лицо ""%1"" уже включено в состав комиссии!'"), ВыбранноеЗначение);
			ПоказатьПредупреждение(, ТекстСообщения, 60);
			СтандартнаяОбработка = Ложь;
		КонецЕсли;

	КонецЕсли;
КонецПроцедуры

#КонецОбласти

