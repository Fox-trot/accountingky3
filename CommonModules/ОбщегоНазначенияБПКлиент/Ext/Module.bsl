﻿
#Область СлужебныйПрограммныйИнтерфейс

// Процедура вызывается из модуля формы документов при обработке оповещения
//
// Параметры:
//   Форма - Управляемая форма, для которой производится обработка оповещения
//   ДокументСсылка - ссылка на документ формы
//   ИмяСобытия - имя обрабатываемого события
//   Параметр - параметр, переданный в обработку оповещения
//   Источник - источник, переданный в обработку оповещения
Процедура ОбработкаОповещенияФормыДокумента(Форма, ДокументСсылка, ИмяСобытия, Параметр, Источник) Экспорт
	Если ИмяСобытия = "ВыполненаЗаписьДокумента" Тогда
		Если ДокументСсылка = Параметр.ДокументСсылка Тогда 
			Форма.Прочитать();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры	

// Проверяет, надо ли записать данные формы до выполнения над ними каких-либо команд.
//
Функция НадоЗаписать(Форма) Экспорт
	
	Возврат НЕ ЗначениеЗаполнено(Форма.Параметры.Ключ) ИЛИ Форма.Модифицированность;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ФОРМОЙ КЛАССИФИКАТОРА

// Процедура - Открыть форму подбора из классификатора
//
// Параметры:
//  ИмяСправочника			 - Строка	 - Имя справочника, как оно задано в конфигурации
//  ПолныйПутьКМакету		 - Строка	 - Полный путь к макету. Пример: Справочник.ВидыТранспорта.Классификатор
//  Заголовок				 - Строка	 - Заголовок окна- как его нужно показать пользователю
//  Форма					 - Форма	 - Форма, из которой выполняется вызов классификатора
//  СоответствиеПолей		 - Структура - Дополнительные поля, которые нужно отобразить пользователю. Поля Код и Наименование отображаются по умолчпнию
//  ОповещениеЗавершения	 - Оповещение	 - Оповещение при завершении
//  ИмяЭкспортнойПроцедуры	 - Строка		 - имя экспортной процедуры, которую необходимо выполнить после подбора.
//
Процедура ОткрытьФормуПодбораИзКлассификатора(ИмяСправочника, ПолныйПутьКМакету, Заголовок, 
		Форма, СоответствиеПолей = Неопределено, ОповещениеЗавершения = Неопределено, ИмяЭкспортнойПроцедуры = "") Экспорт
	
	СтруктураПараметров = Новый Структура("ИмяСправочника,ПолныйПутьКМакету,Заголовок,ИмяЭкспортнойПроцедуры, КлассификаторИзСервиса",
		ИмяСправочника,
		ПолныйПутьКМакету,
		Заголовок,
		ИмяЭкспортнойПроцедуры);
		
	Если СоответствиеПолей <> Неопределено Тогда
		СтруктураПараметров.Вставить("СоответствиеПолей", СоответствиеПолей);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("Форма, ОповещениеЗавершения", Форма, ОповещениеЗавершения);
	Оповещение = Новый ОписаниеОповещения("ОткрытьФормуПодбораИзКлассификатораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("ОбщаяФорма.ЗаполнениеСправочниковИзКлассификаторов", СтруктураПараметров, Форма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Продолжение процедуры ОткрытьФормуПодбораИзКлассификатора
//
Процедура ОткрытьФормуПодбораИзКлассификатораЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	// Обновление списка формы владельца
	ДополнительныеПараметры.Форма.Элементы.Список.Обновить();
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения);
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проверка актуальной версии конфигурации

Процедура ПредупредитьОНеобходимостиОбновленияПрограммы(ПараметрыРаботыКлиента) Экспорт
	
	ТекстСообщения =  НСтр("ru='Используемая сейчас версия конфигурации была выпущена более двух месяцев назад.
	|
	|За это время выпущена новая версия, в которой отражены изменения законодательства и форм отчетности. Новые версии всех конфигураций размещаются на диске ИТС и на пользовательском сайте.
	|
	|'");
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОткрытьОбновлениеПрограммы", Ложь);
	
	Если ПараметрыРаботыКлиента.ЭтоАдминистраторСистемы И ПараметрыРаботыКлиента.ЭтоГлавныйУзел Тогда
		
		#Если ВебКлиент Тогда
			Параметры.Вставить("ТекстСообщения", ТекстСообщения + НСтр("ru='Обновление конфигурации недоступно в веб-клиенте, рекомендуется открыть программу в тонком клиенте.'"));
			ОткрытьФорму("ОбщаяФорма.НерекомендуемаяВерсияКонфигурации", Параметры);
			Возврат;
		#КонецЕсли
		
		Параметры.Вставить("ТекстСообщения", ТекстСообщения + НСтр("ru='Вы можете обновить конфигурацию прямо сейчас.'"));
		Параметры.Вставить("ОткрытьОбновлениеПрограммы", Истина);
	Иначе
		Параметры.Вставить("ТекстСообщения", ТекстСообщения + НСтр("ru='Для обновления конфигурации обратитесь к ответственному за обновление.'"));
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.НерекомендуемаяВерсияКонфигурации", Параметры);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Открытие путеводителя по началу работы в 3.0

Процедура ОткрытьНачинаемРаботатьВ30(ИмяОбработки) Экспорт
	
	ОткрытьФорму("Обработка." + ИмяОбработки + ".Форма");
	
КонецПроцедуры

Процедура ОткрытьПечатьПараметровУчета(ИмяОбработки) Экспорт
	
	ОткрытьФорму("Обработка." + ИмяОбработки + ".Форма");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС ПОЛЯ ВЫБОРА ОРГАНИЗАЦИИ
//

Процедура ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация, Организация) Экспорт
	
	Если Не ЗначениеЗаполнено(ПолеОрганизация) Тогда 
		Организация                       = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, СоответствиеОрганизаций, Организация) Экспорт 
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Значение = СоответствиеОрганизаций[ВыбранноеЗначение];
		Если ТипЗнч(Значение) = Тип("Структура") Тогда 
			Организация = Значение.Организация;
		Иначе
			Организация = Неопределено;
		КонецЕсли;
	Иначе
		Организация = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка, ПолеОрганизация, СоответствиеОрганизаций) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ПолеОрганизация) Тогда
		Если СоответствиеОрганизаций.Свойство(ПолеОрганизация) Тогда
			Значение = СоответствиеОрганизаций[ПолеОрганизация];
			Если ТипЗнч(Значение) = Тип("Структура") Тогда				
				ПоказатьЗначение( , Значение.Организация);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции работы со списками в формах.

// Возвращает текущие данные динамического списка.
//
// Параметры:
//  Список  - <ДинамическийСписок> - динамический список.
//
// Возвращаемое значение:
//   <ДанныеФормыСтруктура>   - текущие данные списка.
//          Если в списке нет активной строки или активной является строка группировки - возвращается Неопределено.
//
Функция ТекущиеДанныеДинамическогоСписка(Список) Экспорт

	Если Список.ТекущиеДанные = Неопределено Тогда // Нет текущей строки.
		Возврат Неопределено;
	ИначеЕсли Список.ТекущиеДанные.Свойство("ГруппировкаСтроки") 
		И Список.ТекущиеДанные.ГруппировкаСтроки <> Неопределено Тогда // Это строка группировки.
		Возврат Неопределено;
	Иначе
		Возврат Список.ТекущиеДанные;
	КонецЕсли;

КонецФункции

#КонецОбласти