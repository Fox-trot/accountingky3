﻿#Область ПрограммныйИнтерфейс

// Определяет объекты конфигурации, в модулях менеджеров которых размещена процедура ДобавитьКомандыПечати,
// формирующая список команд печати, предоставляемых этим объектом.
// Синтаксис процедуры ДобавитьКомандыПечати см. в документации к подсистеме.
//
// Параметры:
//  СписокОбъектов - Массив - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Справочники.ОсновныеСредства);
	СписокОбъектов.Добавить(Справочники.Организации);
	
	СписокОбъектов.Добавить(Документы.АвансовыйОтчет);
	СписокОбъектов.Добавить(Документы.АктСверкиВзаиморасчетов);
	СписокОбъектов.Добавить(Документы.ПоступлениеБланковСчетовФактур);
	СписокОбъектов.Добавить(Документы.ВедомостьЗаработнойПлаты);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровОтПокупателя);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровПоставщику);
	СписокОбъектов.Добавить(Документы.ГТДПоИмпорту);
	СписокОбъектов.Добавить(Документы.ДвижениеМБП);
	СписокОбъектов.Добавить(Документы.Доверенность);
	СписокОбъектов.Добавить(Документы.ДополнительныеРасходы);
	СписокОбъектов.Добавить(Документы.ЗаявлениеОВвозеТоваров);
	СписокОбъектов.Добавить(Документы.ЗемельныйНалог);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияОС);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияТоваров);
	СписокОбъектов.Добавить(Документы.Командировка);
	СписокОбъектов.Добавить(Документы.Конвертация);
	СписокОбъектов.Добавить(Документы.НалогНаМусор);
	СписокОбъектов.Добавить(Документы.ОперацияБух);
	СписокОбъектов.Добавить(Документы.Отпуск);
	СписокОбъектов.Добавить(Документы.ОтчетПоБланкамСчетовФактур);
	СписокОбъектов.Добавить(Документы.ОтчетПоНалогуНаИмущество);
	СписокОбъектов.Добавить(Документы.ОтчетПоНДС);
	СписокОбъектов.Добавить(Документы.ОтчетПоНСП);
	СписокОбъектов.Добавить(Документы.ОтчетПоТруду);
	СписокОбъектов.Добавить(Документы.ОтчетыПоНалогамЗП);
	СписокОбъектов.Добавить(Документы.ПеремещениеОС);
	СписокОбъектов.Добавить(Документы.ПеремещениеТоваров);
	СписокОбъектов.Добавить(Документы.ПлатежноеПоручениеИсходящее);
	СписокОбъектов.Добавить(Документы.ПоступлениеТоваровУслуг);
	СписокОбъектов.Добавить(Документы.ПриемНаРаботу);
	СписокОбъектов.Добавить(Документы.ПринятиеКУчетуОС);
	СписокОбъектов.Добавить(Документы.ПриходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.РаботаВВыходныеИПраздничныеДни);
	СписокОбъектов.Добавить(Документы.РаботаСверхурочно);
	СписокОбъектов.Добавить(Документы.РасходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.РеализацияТоваровУслуг);
	СписокОбъектов.Добавить(Документы.РегламентированныйОтчет);
	СписокОбъектов.Добавить(Документы.СписаниеОС);
	СписокОбъектов.Добавить(Документы.СписаниеТоваров);
	СписокОбъектов.Добавить(Документы.СчетНаОплатуПокупателю);
	СписокОбъектов.Добавить(Документы.СчетФактураВыписанный);
	СписокОбъектов.Добавить(Документы.ТребованиеНакладная);
	СписокОбъектов.Добавить(Документы.ТрудовоеСоглашение);
	СписокОбъектов.Добавить(Документы.Увольнение);
	СписокОбъектов.Добавить(Документы.ОприходованиеТоваров);
	СписокОбъектов.Добавить(Документы.ОтчетПоНалогуНаПрибыль);
	СписокОбъектов.Добавить(Документы.ОтчетПоЕдиномуНалогу);
	СписокОбъектов.Добавить(Документы._ДемоПлатежныйДокумент);
	СписокОбъектов.Добавить(Документы.ОтчетПоКосвеннымНалогам);
	СписокОбъектов.Добавить(Документы.УведомлениеОПолученииТоваров);
	СписокОбъектов.Добавить(Документы.ОтчетВзаимнойОТорговлеЕАЭС);
	
	СписокОбъектов.Добавить(ЖурналыДокументов.ЖурналОпераций);
	СписокОбъектов.Добавить(ЖурналыДокументов.ПроизводственныеДокументы);
	
КонецПроцедуры

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Используется в случае, когда необходимо сократить список форматов сохранения, предлагаемый пользователю
// перед сохранением печатной формы в файл, либо перед отправкой по почте.
//
// Параметры:
//  ТаблицаФорматов - ТаблицаЗначений - коллекция форматов сохранения:
//   * ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента - значение в платформе, соответствующее формату;
//   * Ссылка        - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на метаданные, где хранится представление;
//   * Представление - Строка - представление типа файла (заполняется из перечисления);
//   * Расширение    - Строка - тип файла для операционной системы;
//   * Картинка      - Картинка - значок формата.
//
Процедура ПриЗаполненииНастроекФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
КонецПроцедуры

// Переопределяет список команд печати, получаемый функцией УправлениеПечатью.КомандыПечатиФормы.
// Используется для общих форм, у которых нет модуля менеджера для размещения в нем процедуры ДобавитьКомандыПечати,
// для случаев, когда штатных средств добавления команд в такие формы недостаточно. Например, если нужны свои команды,
// которых нет в других объектах.
// 
// Параметры:
//  ИмяФормы             - Строка - полное имя формы, в которой добавляются команды печати;
//  КомандыПечати        - ТаблицаЗначений - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати;
//  СтандартнаяОбработка - Булево - при установке значения Ложь не будет автоматически заполняться коллекция КомандыПечати.
//
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные настройки списка команд печати в журналах документов.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Если установлено значение Ложь, то список команд печати журнала будет
//                                         заполнен вызовом метода ДобавитьКомандыПечати из модуля менеджера журнала.
//                                         Значение по умолчанию: Истина - метод ДобавитьКомандыПечати будет вызван из
//                                         модулей менеджеров документов, входящих в состав журнала.
Процедура ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка) Экспорт
	
КонецПроцедуры

// Вызывается после завершения вызова процедуры Печать менеджера печати объекта, имеет те же параметры.
// Может использоваться для постобработки всех печатных форм при их формировании.
// Например, можно вставить в колонтитул дату формирования печатной формы.
//
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - информация для заполнения письма при отправке печатной формы по электронной почте.
//                                     Содержит следующие поля (описание см. в общем модуле конфигурации
//                                     РаботаСПочтовымиСообщениямиКлиент в процедуре СоздатьНовоеПисьмо):
//    ** Получатель;
//    ** Тема,
//    ** Текст.
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// Может использоваться, например, для подготовки текста письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - коллекция параметров:
//   * Получатель - Массив - коллекция имен получателей;
//   * Тема - Строка - тема письма;
//   * Текст - Строка - текст письма;
//   * Вложения - Структура - коллекция вложений:
//    ** АдресВоВременномХранилище - Строка - адрес вложения во временном хранилище;
//    ** Представление - Строка - имя файла вложения.
//  ОбъектыПечати - Массив - коллекция объектов, по которым сформированы печатные формы.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//   * Название - Строка - название печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатая форма.
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	
КонецПроцедуры

#КонецОбласти
